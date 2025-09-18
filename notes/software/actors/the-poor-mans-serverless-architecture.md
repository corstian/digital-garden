---
title: "The poor man's serverless architecture"
layout: default
date: "2024-02-04"
---

Serverless technology has gained popularity in the recent years. Primary drivers behind this phenomenon are initial low costs to develop, iterate, deploy and run. This in turn is amplified by the vendor lock-in easily achieved by the big cloud vendors offering this technology. While there are undoubtedly benefits they derive from the scale at which they operate serverless infrastructure, the costs associated with operating on such highly advanced infrastructure is too great to be able to scale up with.

To make the cloud work for small and resource constrained start-ups you'll need to be smart with the available resources. While there are some unicorns benefiting from the ability to rapidly scale on-demand - _and are willing to bear the costs for this_ - it is generally far more beneficial to most companies to keep the cost of infrastructure as low as possible. In early stage startups to increase the runway, and at later stages to have more money which can be put into further growth.

## Be smart with cloud infrastructure
The main benefit from serverless systems is the elastic scalability it provides, both up and down. This scalability is facilitated by the small operations comprising such a system. An application being able to scale in much the same way is not impossible to build, even for a small organization with only a few (proficient) developers.

The dynamic scaling of applications primarilly relies on the availability of unused compute resources. This dynamic scalability therefore is barely accessible to parties not having access to excess capacity. While to a certain extent we are still tied to a cloud vendor, we can definitely utilize their generally cheaper excess capacity. _([Although this post suggests the cost savings by using spot pricing are getting slashed.](https://pauley.me/post/2023/spot-price-trends/))_

To be able to build these two things together we should come up with a software architecture which supports these finely grained operations, which can then be deployed to infrastructure in ways which do in fact properly scale.

What we get as a results isn't any longer serverless in the sense of "we do not know how this code runs on servers but it does" but rather serverless in the sense of "we do not own (most of) our servers but are able to temporarily rent if any capacity is necessary".

The benefit which comes with bringing your own serverless infrastructure to a cloud vendor is that you are no longer paying for the vendors own serverless infrastructure. Therefore it no longer matters whether or not your loads are predictable. You can just deploy your own serverless-ish system to bare metal machines to have baseline capacity, and compensate for excess by renting or abandoning temporary compute resources.

Using this approach you'll even gain independence from the clouds specific flavour of serverless as you're able to run on bare metal instances. If your application supports geographic distribution as well _(which is difficult due to latency and what not)_ it becomes possible to mix and match cloud vendors based on their pricing and offering. It'd be possible to rent some bare metal OVH boxes for baseline capacity, and rent additional capacity from Google, Microsoft or AWS, depending on market dynamics.

> Whenever one is in such position the fun begins by optimizing workloads and dynamically shifting them across regions based on surplus energy, thus optimizing ones carbon impact.

## Practical building blocks
Like mentioned before such approach isn't completely inaccessible, even for small organizations. The key to achieving such elastically scalable application is the use of ready made building blocks. One of the most important components for this is an [actor system](/notes/software/actors/). The unit of scale is a single actor, and the total consumption of resources is equal to the sum of utilization by all actors. To keep such a system running it is important to either deallocate actors to make space for new ones, or to increase capacity by adding nodes.

While the actor is merely an architectural abstraction, the most complicated areas exist on either side of this abstraction. The first one is about infrastructure. Just because this abstraction facilitates the dynamic scaling of infrastructural resources, does not mean that it automatically does. On the other end we are dealing with the architecture of our software itself, with the question about how one is going to fit their workload within the conceptual model of an actor system.

## A Minimum Viable Product
It is reasonable that a small start up does not yet have the resources to create a globally replicated application. At the same time it is still possible to create a dynamically scalable application with very little resources.

As this is an endeavour I spent quite some time on in the past I'll just link to this repository for my prior work on this topic; [whaally/domain](https://github.com/whaally/domain).