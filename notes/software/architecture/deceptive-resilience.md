---
title: "Deceptive Resilience"
date: 2025-07-29
---

Deceptive Resilience
====================

Oftentimes overly cautious code is tauted as being resilient. This is code generally wrapped into numerous try-catch blocks and contains a plethora of if/else statements. Although this most likely serves a purpose, and had been written for a reason, code like this causes the state-space to explode, making one less-likely to properly handle (current and) future edge-cases.

The simpler and less-cautious code is arguably more safe to work with for the following reasons:

- Easier to reason about
- More transparent to errors (fail fast & hard)
- Reduced state space

Generally this evolves due to a number of challenges:

- Code fails in unexpected ways (state-space related)
- **Failures are swallowed by the application due to an incorrectly engineered concurrency model** (_this one is treacherous, but warrants investing the work to resolve the root cause_)
- Challenges properly validating input
- A complex business domain


## Input validation
There are various philosophies about how to deal with data validation within a given system; which seem to converge towards one of the following:

- Validate at the boundaries of the system
- Validate at the core of the system
- Validate everywhere

It is the latter which I have only seen as a coping strategy when the first one fails to deliver. For this reason I do prefer validation at the very core of the system. Right before an operation is being evaluated. This allows one to pass information throughout the system without having to worry about validating it. If the data cannot be dealt with you (or the end user) will know.

## Failure handling
There are various reasons I have seen try-catch blocks exist all over the place:

- Swallowed exceptions
- Lack of input validation (e.g. to catch null reference exceptions)
- Lack of standardized logging/telemetry (e.g. catch blocks to log failures)
- Complicated business logic failing in unexpected ways

Most of these problems cannot be solved by a quick fix. One can however gradually work towards cleaning up this code. The guiding principle therein is "***Fail fast and fail hard***". Most of the time this means not having try-catch blocks to catch errors, and if an error is thrown which cannot be dealt with locally, it should be rethrown for a parent handler to deal with.

This approach works especially well in conjunction with proper logging practices in the application. Ensuring failures show up somewhere visible to the development team allows the team to prioritize work most urgently needed. Going through these motions for a while might be painful at first, but allows one to end up in a better situation with more cleaner-maintainable and stable code; consequently freeing up time again for feature development.
