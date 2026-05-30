This document is there primarily to remind me of the options available to hide side-effects from domain models. In order to keep the code domain model itself maintainable and testable, the idea here is to move any unnecessary dependencies out of the model elsewhere. Side effects here involve database storage, external APIs and the like.

Lets start sketching.

A bare bones aggregate may look like this:

```csharp
public record Profile {
    public string Email { get; init; }
}
```

This is just a POCO (Plain Old C# Object), DTO (Data Transfer Object) or whatever your name of choice is. There is not yet any logic attached to mutating a field. We would technically be able to do something like: `new Profile () { Email = "+3112345678"; }`, which leads to utter and horrible confusion on part of the end-users. Additionally right now we're unable to change things.

Addressing these shortcomings we'll change our profile aggregate like this:

```csharp
public record Profile {
    public string Email { get; init; }

    public void SetEmail(string email) {
        if (email.Contains("@")) Email = email;
    }
}
```

All is good now. But how are we going to store our changes in a database? Currently there are two distinct options for this:

1. The `SetEmail` method takes a dependency on a repository responsible for persisting the profile object
2. This responsibility is offloaded to the consumer of the domain

Both these options feel dissatisfactory at best. As soon as we use a repository within the aggregate we can no longer test the behaviour of our aggregate independently from the repository. At best we'd have to mock the repository. An additional issue here is that we can no longer compose behaviour without persisting the intermediate change-set in between. This latter issue can however be resolved by embedding repositories within the unit-of-work pattern.

The latter option puts the responsibility for storing changes with the consumer of the domain model. This is rather unsatisfying as soon as a domain model is consumed multiple times.

