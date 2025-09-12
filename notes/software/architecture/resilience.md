---
title: "Technical Resilience"
date: 2025-07-28
---

Technical Resilience
====================

Technical resilience of applications comes in many forms. Two important aspects are redundancy (having fallback options) and slack (having spare capacity).

## Coupling between systems and resilience
The actor model of computation is an incredibly powerful mental model enabling flexible scaling of ones applications. While in my humble opinion such architecture is among the most resilient out there, it comes with a number of drawbacks around its implementation. Not in the least place the impact it has on downstream dependencies and infrastructure.