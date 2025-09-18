---
title: "Software Estimation"
date: 2024-09-05
toc: false
layout: default
---

The estimation of software development processes is a controversial topic. Not in the first place because estimates are generally horribly off-target, and are consequently used as a tool to defer blame.

This topic can be approached from various different perspectives:

1. Estimation accuracy as a consequence of uncertainty
2. Estimates as a surrogate for being in control

[A most insightful take on estimation is that it can be replaced by managing dependencies](https://old.reddit.com/r/programming/comments/1f9bjr5/software_estimation_is_hard_do_it_anyway/llkvt68/). The change here is not to attempt to deliver by a given date, but instead "as soon as possible". Also, with decent insight into the dependencies required to finish a piece of work, it is possible to continuously update estimates as new information comes in. In this case an estimate would be based on the current understanding of a bottleneck, rather than the work to be done in the traditional sense.

This leads us to the first point; estimates as a consequence of uncertainty. Oftentimes estimates are overrun due to [unknown-unknown factors](https://en.wikipedia.org/wiki/There_are_unknown_unknowns). Whether these are due to temporal obliviousness or aspects we had never encountered before does not matter. The end result is that the assessment of the work to be done was incorrect, and lacked the necessary detail to make an accurate assessment. To be able to deal with this software should be constructed in a fully transparent manner. Such software should be able to communicate - through its architecture - how it functions. Through such explicit architecture it should be possible to clearly and accurately assess the work to be done for routine \[software maintenance / development\] tasks.

> As a concrete example of such transparent architecture are those where the infrastructure is fully decoupled from the actual behaviour of the system (the business rules). This way it becomes possible to solely focus on the implementation of business rules, without worying about infrastructure, reducing the amount of uncertainties and side effects encountered navigating the code base.

It is through the lack of such transparent architecture where unknown-unkown factors are continuously encountered. At this point it is dependent upon the culture to determine how such thing is dealt with. In high performing teams the root-cause of these issues is oftentimes identified and resolved. In other environments however blame is shifted on the individual developer for it's inability to produce accurate assessments. Needless to say this is highly detrimental to the amount of psychological safety in a given team, and actively blocks any remedial action in the future. One is bound to be stuck in continous fire-fighting mode this way.
