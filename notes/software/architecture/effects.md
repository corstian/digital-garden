---
title: "Effects"
date: 2025-09-12
---

# Effects

An effect system is a formal mathematical model which is able to describe the side-effects of a given computation[^1]. Effect systems exits in close relationship with functional systems. In the latter any (side) effects are already pushed to the boundaries of the system as to maintain "purity". In the context of functional programming, effects are a way to maintain purity, while retaining the ability to locally describe side effects.

It should be noted that the focus of effect oriented programming seems to lay around low-level operations such as file IO and networking. This is sensible from the functional perspective whereas the goal is achieving functional purity of operations by pushing out side-effects. This is not what I want to focus on.

The mere act of pushing out side-effects through effects does not necessarilly improve system performance. Without further changes a system will still have to resolve the same asynchronous operations before being able to continue its computation, possibly containing further asynchronous operations. Taking a look at effect systems from a performance and efficiency perspective I'd argue it is more beneficial to take a look at effects from a higher abstraction level. Not so much thinking about individual operations necessary to complete an operation, but instead as a collected assortion of side effects to be ran in parallel. For sake of clarity in this article lets just call those parallel effects.

One of the biggest issues encountered implementing something akin to these "parallel effects" is the interdependence of side-effects. In an ideal system no such dependencies exist, thus allowing the parallel execution of these side-effects. In the practical reality of the world this clashes with how we think about side effects, those generally being imperative logic telling a program how to achieve a thing. E.g. "read this file" or "store this database record". The main problem which arises with this approach is that these imperative side-effects do not compose nicely. More concrete; having database operations defined as effects does not mean a program will be able to magically combine these operations into one.

The reason for this is twofold. First there is the complexity of the infrastructure and an impedance mismatch. The abstraction level at which one wants to combine operations does not match well with the intricacies one would need to consider and compensate for when dealing with specific infrastructure. Second - and perhaps more important - is the dependence of these side-effects on specific code paths. Unless code-paths can be analyzed and predicted beforehand (which one cannot if they are dependent on side-effects), the comprehensive combination of side-effects will be impossible.

It is fair to state that one can apply effects either in an imperative or a functional manner. One describes how a certain changes should be applied, while the other describes what changes should be applied. Although a subtle difference, the imperative manner actively stands in the way of composing operations. It is through telling the application what should be done (i.e. by passing certain metadata) that the application can use that information to determine how to achieve those requested changes. Using effects to pass on the latter is one step to composing more supple applications.

## Domain behaviour

In the context of system design effects can be a huge help to the design of performant domain models. When one designed their design interaction in an imperative manner behaviour generally follows this flow:

1. Retrieve the requested object from the database
2. Check if the requested changes can be made
3. Apply the requested changes back to the database

While perfectly fine for a single object, it is in practice often necessary to group multiple of these operations in a single transaction scope. In such cases roundtrip times to the database amounts to $2N$ where $N$ is the number of objects needing to be touched. An alternative can be achieved using effects by describing both the operation(s) and the subject(s). It is in this scenario that one can apply all changes in 2 database roundtrip times (RTT); that is under the assumption all of the necessary information is available beforehand.

> The potential gains are remarkable. A query to retrieve the necessary information merely adds 1 RTT, amounting to a total of 3 RTT. If one were to execute these operations against two individual objects total roundtrip time would already amount to 4.

At the same time it should be acknowledged that performance is only one aspect of a technical domain implementation. Another important aspect here is data integrity. What happens to global state? It is this area where effects bring further improvements as well. Since side-effects are no longer applied indiscriminately, one can evaluate intermediate state before applying all side-effects all at once. The concrete implication of this is that if there is a failure anywhere along the way, the whole operation can be cancelled without having to revert any already side-effect whatsoever. 

It is this thing which might as well be the icing on the cake. Doing this prevents the necessity of vast amounts of error-prone and generally barely-tested compensatory code paths. Last but not least it should be noted sometimes failure handling is necessary. It is such approach however which forces one to make these cases a first class citizen of the domain model, giving it all the perks and visibility as all success paths usually have as well.

This does come with a certain catch however. While it is possible to compose complex behaviour out of simple building blocks one should be aware about the evaluation dynamics of such model in case a failure is encountered. There are essentially two ways one can deal with errors in this case:

1. Stop further evaluation in case of an error. The implication is that the returned errors are not comprehensive, and more errors surface once the original issue is resolved.
2. Continue evaluation, although with potentially incorrect domain data. In this case the reported errors are not representative either.

While the composition of behaviour is possible - simple even -, it is impossible to guarantee the full reporting of all errors with a given operation. While not so much a dealbreaker, this might be something to consider while working with composable behaviour.

## Closing remark

The irony is that this approach wraps itself back around to (purely) functional programming again, whereas we are pushing the actual side-effects out to the boundaries of the application. Additionally rather than describing "how" we want to achieve said side-effects we started to - in line with functional paradigms - describe what side-effects we want to achieve. It is by pushing the "what" out to the application boundary that we are able to achieve a bunch of significant performance optimizations.

[^1]: https://en.wikipedia.org/wiki/Effect_system