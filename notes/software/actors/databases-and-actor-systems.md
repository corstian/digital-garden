---
title: "Databases and actor systems"
layout: default
toc: true
---

# Databases and actor systems
Even though an actor system itself can be highly scalable, in most cases (and I wouldn't really recommend anything else) such system is still connected to a single (non-scalable) database instance. Is it for that reason then that we shouldn't write elastically scalable systems alltogether?

Personally I would argue for this not to be the case. Some of the properties of actor systems still persist, regardless of whether the backing database is elastically scalable or not:
- Elastic scalability, therefore:
    - Only pay for consumption of resources
    - Scale to 0 when not in use
    - Easily deal with spikes in traffic patterns
- Relatively straightforward blue/green deployments
- Actors may act as a caching layer to any backing store
- Extensive failure-recovery options

Overall a properly developed actor system significantly increases application resiliency.

## Scaling databases
In the situations when a database does in fact need to scale up to meet demand, we are generally left with two options:

1. Put the database on a bigger box (vertical scaling)
2. Shard the database and run multiple instances (horizontal scaling)

This is up to the specific database tech in use, and does not necessarily involve the actor system either.

## Hyperscaling databases
But what if a normal database system no longer works? What if the volume of data is such that no off-the-shelf database is able to deal with the set constraints? In that case one might consider building their own database system on top of the actor model.

> **Unless someone is paying you to research such technology I explicitly discourage you from pursuing such endeavour for a production system.**

Ultimately the core technology of a database revolves around the organisation of information on storage mediums. Ultimately this is where all tradeoffs in database systems come from. The available resources need to be balanced to provide acceptable insertion performance, as well as acceptable read performance. What the conditions are and what is considered "acceptable" under these conditions all needs to be specified as that'll heavily impact the concrete architecture of the system itself.

That said, actor systems may as well not be the tool of choice for distributed low-latency data retrieval systems. This is primarilly due to the network latency inbetween single nodes. While this can fall within acceptable limits if these nodes are placed within the same data center, this will certainly not be the case if an actor system is distributed all over the world.

When considering the elastically scalable aspect of actor systems as it's strength another area appears where they start to shine, which is cheap and massive data storage. In this area response times is generally of a lesser concern than the cost of storage. At the same time we might want to retain some query abilities over the data we're storing, as it's simply too big to store in a traditional data store. However, data would be too big to hold into memory all at the same time, and as such we only expect a small subset of this data to be loaded at any point in time. The actor system therefore provides a scalable interface to the underlying storage interface, allowing to elastically scale with demand. This is probably the most scalable we can make a data store until we get to the actual storage layer.

> In practice it is definitely viable to create an actor based storage system having limited query capabilities costing less than $0.30/TiB/day. Not considering the cost of nodes running the actor system itself. Possibly even cheaper if you procure the storage racks yourself.

A necessity for running a database as an actor system is the independent functioning of the storage layer and the database system from one another. This is how it becomes possible to have a far bigger database than anything you have the computational resources to run. At the same time this is also where the complexity of the database system exists. When running a database you will be required to maintain knowledge about the location of certain objects, even when these objects are currently not available.

While there is a wide variety of ways one can distribute data and metadata alike across a cluster, there is one approach I have been most inspired by which had been described in the paper ["Index based query processing on distributed multidimensional data"](/notes/papers/index-based-query-processing-on-distributed-multidimensional-data). The gist of this approach is that a multi dimension k-d tree is constructed where the data - alongside some metadata about the tree - is stored in the leaves of the tree. This allows rather efficient retrieval of information as long as all dimensions are known. While this data structure scales extraordinarily well across a cluster the major downside is that there is no straightforward approach to change the dimensions based on which the data is indexed. In order to do so one must fully rewrite data structure. There is no straightforward way one can do this iteratively either, while keeping the store available. Depending on the requirements this might be a blocker.

However, in the specific use case where the indexing dimensions of the data are well known ahead of time this might prove to be a brilliant approach to create a highly scalable data store for the data at hand, one that can even be queried reasonably straightforward. The risk of identifying limitations in the indexing structure after initial deployment are rather high, and therefore I would not quickly recommend going ahead with such approach, even when given a concrete specification.

An area where these constraints do not matter as much however is in the development of a meta-model used to capture data with. The benefit of a meta model is that it abstracts the information contained in the system. This meta model can then be used to design query functionality with, which does not need to know about the specific information contained in the system. This in itself is rather useful for the development of things such as triple stores, and related thereto graph databases. While these are still subject to the very same constraints (e.g. immutable index dimensions), it's much easier to work around these constraints to deliver flexible software which works at scale.

