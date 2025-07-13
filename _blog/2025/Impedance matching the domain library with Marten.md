Impedance matching the domain library with Marten
====

It is remarkably satisfying when software components can be integrated with one another without too much fuss. When there are ways and hooks to integrate software in a way which makes it seem as if they fit seamlessly.

> If you are interested in running the domain library and Marten, just copy paste the examples in this post. There's not going to be a nuget package. Configuration tweaks are just easier to do in code; e.g. do you want sequential or parallel 

This had been my experience integrating the `Whaally.Domain` library with Marten. Earlier I had been hosting the domain library on top of Orleans, allowing some more leeway in integrating these three libraries together. Now in this experiment however I had been attempting to create an easily hostable (that means no clusters) integration just consisting of the domain library to organize logic, and Marten for persistence.

