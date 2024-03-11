---
title: "What is Event Sourcing?"
slug: "what-is-event-sourcing"
date: "2022-07-24"
summary: "This post attempts to explain event sourcing through examples showing what it is and what it is not, while highlighting some of the strengths and reasons for using it."
references: 
  - '[[202201200000 event-sourced-aggregates]]'
  - '[[202208050000 boring-complexity]]'
toc: false
---

#software-development #dotnet

The architectural concept of event sourcing (ES) is often encountered in combination with those of domain driven design (DDD) and command/query responsibility segregation (CQRS). While the combination of DDD with ES and CQRS is a powerful one, you do not need to understand these concepts to understand what event sourcing is about. In this post I will demonstrate a minimum example of what it is.

Skip to the end of the article for an abstract overview.

## What one is missing out on without event sourcing
Take a look at this plain old class object (POCO) to see how one would normally represent data:

```csharp
public class Car {
    public string Registration { get; set; }
}
```

Generally one may edit this class wherever they can access it from, and store it in a database using an object-relational mapper (ORM) like Entity Framework (EF) or Dapper.

> Though I would not recommend changing an object from wherever you have access to it, that is not the point of event sourcing. For more info about why that is, look into the concept of domain driven design.

Changing the information held by an instance of `User` would look like this:

```csharp
var car = new Car();

car.Registration = "XX-YY-123";
```

And it does the job. The information is updated, and everyone might be happy. Or at least for a short period of time, since there are some (severe) limitations to this approach.

### Implicitly deleting data
The main problem in this process is that any change of information removes the previous data held by that field. To resolve this we may alter the `Car` object to hold onto previous data like this:

```csharp
public class Car {
    public string Registration { get; set; }
    public List<string> PreviousRegistrations { get; set; }
}
```

And while this might work, maintaining this code becomes more difficult. Changing the registration becomes more difficult since we must ensure that the value is held onto, and is added to the list of previous registrations. And though the structure of the object itself is perfectly valid, we'll certainly encounter more difficulties later on.

### Accessing historic information
One of these limitations is if we want to access historic information. There are multiple solutions to this:

1. We model the historic information to be a part of the object, as had just been discussed
2. We create a mechanism through which we can recover the previous version of the object
3. We keep track of the operations that had previously been applied to the object

Both flexibility and complexity increases with this list. It's the last option that is what makes up event sourcing; the collection of operations that had been executed against the object.

### Allowing the object to change
With this simple POCO discussed previously we'll run into significant troubles if we wish to refactor the object later on, and this specifically is perhaps the most important argument for why one would want to use event sourcing. Changing a single POCO would be a cumbersome process if information about previous operations had perished. Changing it anyway would require an intermediate object state which allows one to map old fields to the new ones, and then an additional step to definitively remove the old fields.

The result of this is that objects, once designed, barely change. This resistance to change in a system will certainly increase the degradation of the system, and severely limit its economically viable life-time.

## How event sourcing may help
Event sourcing techniques help by modelling the operations ran on an object, rather than the shape of the object itself. A minimal example might look like this:

```csharp
public class Car {
    public Car(List<ICarEvent> events) {
        Events = events;

        // Reconstruct the current state from provided events
        foreach (var @event in events) {
            @event.Run(this);
        }
    }

    public List<ICarEvent> Events { get; set; } = new List<ICarEvent>();
    public string Registration { get; set; }
}

public interface ICarEvent {
    public void Run(Car car);
}

public class ChangeRegistration : ICarEvent {
    private readonly string _registration;
    public ChangeRegistration(string registration) {
        _registration = registration;
    }

    public void Run(Car car) {
        car.Registration = _registration;
        car.Events.Add(this);
    }
}
```

The exact naming, and organisation of the classes do not matter, and in practice you'll find much more elaborate and complicated set-ups running in production. The important aspects of this example are the following:

1. An object exists with the parameters required to make the change.
2. The change (event) is maintained. In this example it is added to the `Car` object, though normally you'll usually find the events and objects separated.
3. The events are provided through the constructor of the `Car` object. Again, this is not about the constructor, but about making sure that the properties held by the `Car` object can be reconstructed from the list of events that had previously been applied.
4. There must be some logic to apply the event to the object itself. Sometimes you'll find this in the event itself, sometimes in the object, and other times there are specific `EventHandler` objects which sole responsibility is doing so.

### Changing the object itself
Now that we are able to create an object from the list of events previously applied to it, we can change the contents of it, while only changing the way the information from the event is applied to the object. If we wish to retain previous information that might look a bit like this:

```csharp
public class Car {
    public Car(List<ICarEvent> events) {
        Events = events;

        foreach (var @event in events) {
            @event.Run(this);
        }
    }

    public List<ICarEvent> Events { get; set; } = new List<ICarEvent>();
    
    public List<string> PreviousRegistrations { get; set; } = new List<string>();
    public string Registration => PreviousRegistrations.Last();
}

public class ChangeRegistration : ICarEvent {
    private readonly string _registration;
    public ChangeRegistration(string registration) {
        _registration = registration;
    }

    public void Run(Car car) {
        car.PreviousRegistrations.Add(_registration);
        car.Events.Add(this);
    }
}
```

The most important change in this example is that we had altered the way the event is applied to the object. The provided data itself has not changed, though the representation of the object itself has been enriched with historical data.

## What event sourcing is about
Ultimately event-sourcing provides a separation between the representation of data and its actual contents. This results in a conceptual boundary between operations executed against an object and its current state. It's the current state of the object that is derived from all operations. One can then conclude that the current state represents the sum of all events.

The benefit of this approach in day to day development operations is that it is less important to get the data model exactly right. The additional structural overhead of event sourcing facilitates changing the object later on. This allows one to experiment with the data model, and alter it in the future to better fit the everyday reality. It encourages a continuous learning and refactoring process.

To prevent the move of this inability to change from the object to the events one can scope the events to the smallest possible change one can make. This results in a number of events for example to change an address, or a first and last name together. Data which changes together stays together.

The result is that events can be composed to exactly represent the change that is required. The sum of individual events are therefore less subjected to change than the complete object itself is.

> For further background on event sourcing, its integration in a more complex architectural landscape, and practical examples check out the additional references in the sidebar or beneath the article.
