---
title: "Improving projection throughput by increasing batch sizes"
slug: "improving-projection-throughput-by-increasing-batch-sizes"
date: 2024-03-24
toc: false
---

An event-driven system I'm working on contains several hundred million events. To extract useful information from these events these are rolled up through projections. These projections are going through every event (preferrably in sequence), taking the relevant information and applying these to some other data object.

The problem with projections at this scale is that the sequential processing of events takes way too long. One of the heavier projections took about three days to rebuild in this manner. While technically this is not so much a problem it is more of an annoyance from a process perspective, significantly slowing down the feedback loop. After some optimization work the speed at which these projections ran had been improved to about three hours.

Throughout the (relatively short) existence of this projection it had gone through four iterations. To summarize these:

1. The initial proof of concept, sequentially processing events. It proved the concept, but was way too slow. Processing time would have been weeks.
2. The initial optimization step introducing indexes, and adding some custom queries to improve query and insertion speeds.
3. The re-implementation of the projection to allow batch processing of events.
4. Further performance optimizations by caching data locally.

It's the last optimization step which is most interesting. As we continued with batch-based processing we ran various experiments to get a sense of projection performance. At this point in time there was a major problem with the projections. Whereas initially they would run at a speed of 30_000 events/second this would quickly slow down to a trickle of 500 events/second. The challenge therefore was to get the projections to run at a more sustainable speed, which would make the runtime of these more predictable. To achieve this we had been tuning the following parameters:

1. Batch sizes. Where the default had been 500 events, we started playing around with batch sizes of 2000 to 5000. The optimal choice depends on network latency. With higher latencies, bigger batch sizes are more beneficial.
2. We ditched the idea that a projection should retrieve all of its required information in the current run. Instead we start by pre-fetching some data now, and keep updating it in-memory to prevent having to request this information from the database over and over again. This was a huge change. It requires a significant portion of memory to be available on the process running the projections, but frees up the database for other work. For us this is beneficial as computational resources for the projections are cheap and short lived, while changing database provisioning is significantly more expensive and for our use-case relatively wasteful.
3. Whereas we previously surirgically retrieved the necessary information from the database it turned out that it was faster to overfetch information and filter in the projection, rather than let the database do this. Where we were running into limitations on CPU, memory and IOPS, we still had overhead on the bandwidth we could utilize.
4. To compensate for the overfetch we started to experiment with even larger batches of events to process in one run. At this point in time we were experimenting with batch sizes of 100000 or even 1000000. Eventually we settled on a 100000 as this proved to be the more efficient approach.
5. Last but not least we started running SQL COPY commands to ~~insert~~ overwrite data in the database. During the time these projections were running we were considering the projection to be the source of truth writing its data to the database. The database followed. By putting all changes in a single copy command with its appropriate transaction boundary we are still able to keep the database consistent. Even during failure of the projection, or database timeouts.

The results were remarkable. At the start of the projection run we were able to run the projection at a speed of 50000 events/second. Over the course of the run this averaged to 20000 events/second.

Interestingly enough this drop in throughput can largely be attributed to us running out of our allocation of IOPS and bandwidth. This becomes clearly visible when monitoring network utilization from the perspective of the projection daemon. Initially query and write operations transfer information at a pace anywhere between 700 and 900 Mbit/second, where this later slows down to about 10/20 Mbit/second when being throttled.

With the amount of information being processed it is merely a matter of time before the decision is made to upgrade database resources. At the other hand however computational expenses are big enough to warrant an optimization process. In our case the costs associated with allocating the resources necessary to cope with inefficient code are way bigger than the costs necessary for optimizing the system to efficiently make use of the available resources.