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
Most impor