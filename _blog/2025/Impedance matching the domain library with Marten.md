Impedance matching the domain library with Marten
====

It is remarkably satisfying when software components can be integrated with one another without too much fuss. When there are ways and hooks to integrate software in a way which makes it seem as if they fit seamlessly.

> If you are interested in running the domain library and Marten, just copy paste the examples in this post. There's not going to be a nuget package. Tweaking program behaviour is just easier from code.

This had been my experience integrating the `Whaally.Domain` library with Marten. Earlier I had been hosting the domain library on top of Orleans, allowing some more leeway in integrating these three libraries together. Now in this experiment however I had been attempting to create an easily hostable (that means no clusters) integration just consisting of the domain library to organize logic, and Marten for persistence.

## Conceptual overview
The domain library is responsible for organising business logic. It does so by chunking up responsibilities into the following different components:
- 
- Aggregates: responsible for storing state
- Commands: indicate an intent to make a state change against an aggregate
- Events: indicate a state change against an aggregate
- Services: allow composing commands directed towards multiple aggregates
- Sagas: comparable with services although different in the sense that they fire in response to events

Marten is a library providing an abstraction in .NET for working with Postgres. While normal relational storage is one of the things it does, where Marten starts to shine is the event-sourcing mechanisms it contains. It allows the creation of streams, containing events. Then additionally it contains logic for creating projections, based on the published events.

## Integration
These different concepts fit together remarkably well. The stream in Marten would be representative of the aggregate in 