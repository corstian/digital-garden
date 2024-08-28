One thing I still remember from the time I was learning about abstractions was the assertion that in practice one would never swap out infrastructure. The topic I was learning about were repositories, which acted as an abstraction over the data storage layer. In theory these should help decouple behaviour from their operations against storage infrastructure. Back then the point had been raised that one would never swap out the underlying storage infrastructure because it would be deemed too complex of an endeavour, too risky, or simply not worth the hassle.

In the past years a core focus of my own work had been about decoupling infrastructure from behaviour. This in a rather rigorous manner where both sides would not even know about the existence of the other one. The only way these two could interact had been through a predefined abstraction both had to implement. My initial reason for attempting this in the first place had been to be able to focus solely on the functional side of things, without being encumbered by the infrastructure. Over the 1.5 years I'm now running this paradigm in production another benefit came to surface; the ability to modify infrastructure as you go.

As the functional and infrastructural concerns had been fully separated from another, the practical result was a very concisely expressed infrastructural contract which had to be fulfilled. This contract itself worked by proxying functional operations into a sink where the infrastructure could pick up these operations in a generic manner (message passing for the win) and do what it had to do with it. For the functional aspects it wouldn't really matter whether we had been using event-sourcing if we'd just store the aggregates themselves in the database. As such the way the application scales was of no concern to the functional part either, as it would just move along, do it's thing, and defer the responsibilities of scalability and availability to the infrastructural aspects.

Over the period I had working on this project in production it became clear that this separation allowed us to change the infrastructure as we deemed necessary. To indicate the stuff we had done:

- Move from SQL server to PostgreSQL for cost purposes
- Move on from storing the aggregate to introduce event sourcing
- Move onwards from a single machine to running the application on an elastically scaling cluster

All these operations could be done without too much hassle. Key to getting these deployments done reliably had been to get adequate test coverage on the infrastructural parts, asserting they would work correctly with the aforementioned contract. For this of course we could reuse the existing integration tests, making the process a breeze.

Now, at the time of writing, we have come at a turning point for this project. The costs associated with running this project have come to be burdensome. If anything this is a moment where this decoupled approach truly starts to shine:

- Rather than running on a managed kubernetes cluster we'll start using a serverless offering to have more fine-grained financial controls
- Rather than relying on managed PostgreSQL we're looking into more cost-efficient event stores instead

One interesting aspect about this transition is managing the assumptions held about infrastructure, and the way we deal with that. Currently we are relying on an actor system, thus actors are cached for a little bit before being discarded again. Going serverless this is not necessarilly the case, thus we do need to expect additional load on the database for subsequent operations. It's a balancing act. Give or take some.

The problematic part of this process cannot be underestimated either, that is learning to work with a new infrastructure. While code can be technically correct, infrastructure takes some getting used to. Failure modes need to be understood, and the best way to get to understand them is to run in practice. This in practice is the known unknown we'll have to deal with.

## Implementation process
In the remainder of this post I will walk through the work necessary to get this infrastructure to work. This work is based on [the Whaally Domain library](https://github.com/whaally/domain). The infrastructure we will be working with is Azure (Durable) Functions, combined with PostgreSQL for persistence. From code we will use Marten as a library to provide the interactions with PostgreSQL, and directly interface with the Azure Functions. The code presented here exists in the aforementioned repository as well.

The core ideas behind this implementation are as follows:

- Azure Functions will act as a transparent proxy to the domain behaviour
- Each aggregate instance may only run a single operation at a time for consistency reasons

The classes we'll need to implement:

- `IAggregateHandler<TAggregate>` -> This is where most magic happens

## Making non-generic frameworks, more generic
Some frameworks - among which Azure Functions - are rather hard to work with in a generic capacity. These frameworks do not incorporate the notion of generics, or comparable meta-structures. While these frameworks might work fairly well for use-cases entirely within the ecosystem, they do not work along well in a situation like this; where we refuse to keep on writing infrastructure code for the remainder of our lives.

To ensure the serial execution of tasks we're adopting the durable entity from the durable task framework to wrap our existing concept of the aggregate. The durable entity is refered to by two keys: 1) its type and 2) its identity. Unfortunately for us the type cannot be responded to in a generic manner, thus we'll have to resort to encoding the necessary generic information in it's identity. For this we'll create somewhat of a formalized structure to prevent us from shooting ourselves in the foot later onwards.

```csharp

/// <summary>
///     An abstraction still allowing a somewhat strongly typed interaction with the durable entities.
/// </summary>
/// <param name="Id">The ID of the aggregate instance</param>
/// <typeparam name="TAggregate">The aggregate type</typeparam>
public record AggregateIdentity<TAggregate>(Guid Id) : AggregateIdentity(typeof(TAggregate).Name, Id)
    where TAggregate : class, IAggregate;

/// <summary>
///     An object holding the information based on which the aggregate can be instantiated.
/// </summary>
/// <param name="Type">The type of the aggregate to instantiate</param>
/// <param name="Id">The id of the aggregate</param>
public record AggregateIdentity(
    string Type, 
    Guid Id);
```

As this is a rather fundamental aspect in addressing the aggregate handlers, we want to have proof of it's correct functioning, thus we're writing a few tests asserting they work correctly:

```csharp
public class AggregateIdentityTests
{
    [Fact]
    public void AggregateIdentityIsSerializable()
    {
        var id = Guid.Parse("3c1995b0-b02b-40ae-9e25-b71e7170cbb0");

        JsonSerializer.Serialize(new AggregateIdentity("Aircraft", id))
            .Should()
            .Be("{\"Type\":\"Aircraft\",\"Id\":\"3c1995b0-b02b-40ae-9e25-b71e7170cbb0\"}");
    }

    [Fact]
    public void GenericAggregateIdentityIsSerializable()
    {
        var id = Guid.Parse("3c1995b0-b02b-40ae-9e25-b71e7170cbb0");

        JsonSerializer.Serialize(new AggregateIdentity<Aircraft>(id))
            .Should()
            .Be("{\"Type\":\"Aircraft\",\"Id\":\"3c1995b0-b02b-40ae-9e25-b71e7170cbb0\"}");
    }

    [Fact]
    public void StringIsDeserializableToGeneric()
    {
        var id = Guid.Parse("3c1995b0-b02b-40ae-9e25-b71e7170cbb0");
        var str = "{\"Type\":\"Aircraft\",\"Id\":\"3c1995b0-b02b-40ae-9e25-b71e7170cbb0\"}";

        JsonSerializer.Deserialize<AggregateIdentity>(str)
            .Should()
            .BeEquivalentTo(new AggregateIdentity<Aircraft>(id));
    }
}
```

With these tests passing we have some proof that the mapping back and forth works correctly from a language perspective. More tricky is asserting that this works correctly with Azure Functions itself.

As the documentation explicitly states that the object name of a durable entity is case insensitive, it suggests some things are happening with the strings as provided to the framework. As this is a fundamental aspect of the correct functioning of our infrastructure we will need to make our assumptions about the functioning of durable entities explicit. To do this we'll have to resort to integration testing, as using a mock would hide the implementation details of the framework itself. Within this integration test we will have to check whether or not we can address a durable entity. The signal we will be looking for is an exception happening if we are unable to properly deserialize the message, and / or are able to instantiate an aggregate handler.

> For the set up of the integration test I have been inspired by [this post by Tomasz Pęczek using test containers and a dockerized instance of the functions app](https://www.tpeczek.com/2023/10/azure-functions-integration-testing.html). I have skipped over the set up for brevity.


When it comes to the implementation of the durable entity itself, one can choose to utilize either a class based approach or a function based approach for that. The class based approach seemed like a thin veil over the function based approach, obscuring access to necessary information, thus the function based approach had been selected.

To test whether or not the durable entity is properly addressed we want to call the 

## Final notes
Let it be clear - for the record - that I still do not like the way Azure Functions work. In fact I do feel like I have to bend over backwards in order to get Azure Functions to work properly with this paradigm. To a certain extent it feels crazy that it does not even allow one to rely on the strongly typed features available in the language. But hey; it provides serverless capabilities, and with that the cheap and super granular billing, which is nice in its own way. The goal here had been to strictly contain the extent to which I'm involved with Azure Functions to a bare minimum.
