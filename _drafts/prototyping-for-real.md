---
title: "Prototyping For Real"
date: 2024-09-23
toc: false
layout: default
---

# Prototyping For Real
When developing software in a startup the pressure to ship something - anything really - can be rather high. Discussions covering this tend to present the speed of iteration and quality as two opposing forces, something which - in my humble opinion - does not necessarilly need to be the case. Combined with this perspective you'll see an attitude which is best summarized as "ship now, fix later", which when managed improperly amounts to a pile of insurmountable tech-debt necessitating a full-rewrite shortly after inception.

Evidently this is not the lifecycle I am advocating for. Instead I strongly believe it should be possile to move rather fast with software of decent quality. Quality here involves the following aspects:

- Code structured for intuitive navigation
- Codebase set up for easy and tightly scoped extensions
- Architecture set up for independently testable components

With these aspects in place we can move on to more specifics, which are mostly based on the following assumptions:

- Most startups (whether or not delivering a software product) digitize crucial (administrative) information about their business processes
- Most of the complexity in a software system is found in how the digital representation of a given system changes state
- Relatively little of the IT landscape involves magic sprinkle dust (AI, algorithms, systems integration)

Following through these assumptions it becomes evident that it should be as cheap as possible to (correctly) change information contained in a given system; regardless of whether this happens manually, or automatically. Everything else follows from here. I for one would argue that if one is able to change information easily, quickly and correctly, the odds of having to do a full-system rewrite are minimal.

> It should be noted that in this situation another risk arises, specifically being that of the rate of change being too great. While this is amazing for initial development, it puts a bottleneck on the communication practices and whether or not people are able to keep up on a conceptual level. Even if you're the one shaping the conceptual models the risk is you're rushing delivery of these same conceptual models. It requires a certain restraint and discipline to first doctor out a concept before pushing it out for delivery.
> At the same time having that ability to push out changes to software faster than you can properly think them through is an awesome and valuable ability. Not only does it free up a lot of time during day-to-day operations for unrelated work, but it also allows you to deliver at breakneck speeds when there is a need to do so.

It is only when the cost of change is low, that it becomes easier to integrate external systems. It's at this point that we might be able to focus on added-value services, such as the integration of a special-purpose AI system, a custom algorithm, or a system integration. As the cost of integration is marginal, more focus can be put in the development of the tools itself.

## To a practical implementation
While the aforementioned principles are a bit meta on the software development process, there are practical ways to translate these in practice.