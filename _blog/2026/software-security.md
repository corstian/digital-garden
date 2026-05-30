Visualize the existence of some API endpoint accepting the identifier of some other object such that after the operation they form some sort of relationship together. The question then is as follows; do you run an in-depth check to assert that:

1. the referenced object exists
2. the user has access to the referenced object
3. the state of the referenced object accepts being used as reference

Or would you alternatively just create the relationship between both objects and move on with your day?


Back in the good old days of incremental primary keys a readily available attack vector had been object enumeration. Just increase the number of some object and observe how the system deals with it. Nowadays this is more difficult with the use of fairly random and unguessable UUIDs. UUIDs - while unguessable - are not treated as secrets. It is very possible for these to leak out of your system one way or another. A user sharing some link, a list showing publicly available resources and so on. In situations like these, what is going to happen when a malicious party takes one of these identifiers and tries to associate them with an owned resource? Would that provide them access to said resource?