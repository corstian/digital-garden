Impedance matching the domain library with Marten
====

It is remarkably satisfying when software components can be integrated with one another without too much fuss. When there are ways and hooks to integrate software in a way which makes it seem as if they fit seamlessly.

> If you are interested in running the domain library and Marten, just copy paste the examples in this post. There's not going to be a nuget package. Tweaking program behaviour is just easier from code.

This had been my experience integrating the `Whaally.Domain` library with Marten. Earlier I had been hosting the domain library on top of Orleans, allowing some more leeway in integrating these three libraries together. Now in this experiment however I had been attempting to create an easily hostable (that means no clusters) integration just consisting of the domain library to organize logic, and Marten for persistence.

## Conceptual overview
The domain library is responsible for organising business logic. It does so by chunking up responsibilities into the following different components:

- Aggregates: responsible for storing state
- Commands: indicate an intent to make a state change against an aggregate
- Events: indicate a state change against an aggregate
- Services: allow composing commands directed towards multiple aggregates
- Sagas: comparable with services although different in the sense that they fire in response to events

Marten is a library providing an abstraction in .NET for working with Postgres. While normal relational storage is one of the things it does, where Marten starts to shine is the event-sourcing mechanisms it contains. It allows the creation of streams, containing events. Then additionally it contains logic for creating projections, based on the published events.

## Integration
These different concepts fit together remarkably well. The stream in Marten would be representative of the aggregate in the domain library. The events directly map to events, and the projection system can be used to automatically build snapshots of the aggregates; thus allowing one to inspect aggregate state without having to replay all published events.

Depending on ones requirements these systems can also be used to invoke the sagas; the projection does not explicitly need to make changes against the database. Instead the saga logic can be evaluated as part of a projection. This limits the number of times a projection is evaluated. The alternative thereto is to evaluate an saga each and every time it is applied to the aggregate, which consequently also happens when reconstructing aggregate state. Practically these two differ little from one another in regards to how the saga would be implemented. In either case one would have to inspect the current aggregate state to check whether or not a given operation needs to be evaluated.

### Code
Most important in the integration is the `AggregateHandler` implementation. This component governs how the aggregate is interacted with. Fundamentally the only requirement which should be satisfied is that it implements the `IAggregateHandler` interface. In practice however there is a whole lot that is going on in this area, and there are two base implementations we can build upon; the `BaseAggregateHandler`, and `TransactionalAggregateHandler`. The latter is derived from the former, but with additional guarantees about concurrent access of aggregates.

> Some of the things the `BaseAggregateHandler` takes care of are logging/tracing, and managing state transitions against the aggregate. One particularly noteworthy aspect is the management of intermediate state when merely evaluating multiple events.

```csharp
public class AggregateHandler<TAggregate>(
    IServiceProvider services, 
    IDocumentStore store, 
    string id) : TransactionalAggregateHandler<TAggregate>(services, id)
    where TAggregate : class, IAggregate
{
    private bool _isInitializing = false;
    private bool _isInitialized = false;
    private bool _hasEvents = false;
    
    private async Task EnsureInitialized()
    {
        if (_isInitializing || _isInitialized) return;

        _isInitializing = true;
        
        await using var session = store.LightweightSession();

        var events = await session.Events.FetchStreamAsync(Guid.Parse(id));

        if (events.Count > 0)
            _hasEvents = true;
        
        foreach (var @event in events)
        {
            await Apply(new EventEnvelope(
                new EventMetadata
                {
                    AggregateId = @event.StreamId.ToString(),
                    CreatedAt = @event.Timestamp.DateTime
                },
                (IEvent)@event.Data));
        }

        _isInitializing = false;
        _isInitialized = true;
    }

    public override async Task<IResult<EventEnvelope>> Evaluate(CommandEnvelope commandEnvelope)
    {
        await EnsureInitialized();
        
        return await base.Evaluate(commandEnvelope);
    }

    public override async Task<IResultBase> Apply(EventEnvelope eventEnvelope)
    {
        await EnsureInitialized();
        
        var result = await base.Apply(eventEnvelope);
        
        // To ensure the changes not being persisted twice
        if (_isInitializing || result.IsFailed) return result;
        
        await using var session = store.LightweightSession();

        if (!_hasEvents)
        {
            session.Events.StartStream<TAggregate>(
                Guid.Parse(id),
                eventEnvelope.Messages);
        }
        else
        {
            session.Events.Append(
                Guid.Parse(id),
                eventEnvelope.Messages);
        }

        await session.SaveChangesAsync();

        return result;
    }
}
```

Most of the complexity in here revolves around interaction between state and persistence. At first initialization revolves around retrieving events from the event store, and reconstructing the aggregate state using those entries. Note that the aggregate handler has no concept of rehydration and persistence, and as such we're just tacking this onto the evaluate and apply methods. Added complication here, as evident from the instance variables, is that during this initialization process the aggregate handler depends on its own apply method. It prevents us from appending events to the event stream while reconstructing the aggregate.

One aspect up for discussion here revolves around aggregate construction; does one derive the state from the e

The aggregate handler is supplied by a factory object, which should also be implemented. The one I am supplying here is a rather rudimentary 

```csharp
public class AggregateHandlerFactory(
    IServiceProvider serviceProvider,
    IDocumentStore store,
    IAggregateFactory aggregateFactory,
    IMemoryCache cache)
    : IAggregateHandlerFactory
{
    public IAggregateHandler<TAggregate> Instantiate<TAggregate>(string id)
        where TAggregate : class, IAggregate
    {
        if (id == null || !Guid.TryParse(id, out var guid)) throw new ArgumentNullException(nameof(id));

        var handler = cache.GetOrCreate(guid, entry =>
        {
            entry.SlidingExpiration = TimeSpan.FromMinutes(1);
            
            return new AggregateHandler<TAggregate>(serviceProvider, store, id)
            {
                Aggregate = aggregateFactory.Instantiate<TAggregate>()
            };
        });

        return (IAggregateHandler<TAggregate>)handler;
    }
}
```