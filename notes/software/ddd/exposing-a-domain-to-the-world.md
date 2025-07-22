---
title: "Public access to a core domain"
layout: default
date: "2024-02-04"
toc: true
---

# Allowing public access on a core domain
A domain layer generally lives in the very core of an application. It does not have dependencies on anything else, while having loads of dependent components. Generally it contains the most important behaviour of the application as well, and therefore is the most valuable part of the application as it is likely to contain trade secrets.

While the domain generally is already complex enough, additional complicating factors can be found in the dependents on the domain and change management. How are we going to expose this behaviour to the outside world, is it going to be abstracted, and if so, how?

# Change management
Managing changes to the core domain is one of the biggest challenges in the evolution of the domain. For how can we be flexible, and limit the complexity involved with any abstractions over this model?

Most of the time an addition to the domain model is easy, but a change to the model requires updating all dependent components. This is relatively straightforward if all dependents exist within the boundaries of a backend, but becomes significantly more difficult if this same behaviour had been exposed through an API. In this case it is incredibly difficult - if possible at all - to trace all dependent components.

At the same time this is a problem we will run into anyway if we're creating a publicly accessible API.

## Abstracting the domain
The main benefit involved with abstracting a domain model is decoupling it from any implementations, thus allowing relatively independent evolution of the domain layer. 

## Directly exposing a domain model
From a technical and process based perspective there are two benefits to directly expose a domain model to the outside world:

1. One can reuse the conceptual understanding of a domain model on all integrations, whether internally or externally through an API.
2. One doesn't have to design abstractions between the domain and the API, further increasing technical complexity.

Doing this one can think about an API in any shape or form as a mapper between the transport layer and the domain layer. For an HTTP based API this generally means translating the URI, query parameters and  request body to an operation against the domain. One can think about a GraphQL API or even a binary messaging protocol in the same way. This provides immense flexibility in the implementation and maintenance of API technologies.

> Note that there might be valid technical reasons to not want to directly couple an API endpoint to a domain operation. One such reason would be the need for a caching mechanism to prevent the underlying data store from being hammered by all operations. When a specific need like this arises, by all means go on and come up with a customized design.

From here onwards one can use the same domain model not only with the internal development team, but also when speaking with customers. It simplifies communication not having to think about multiple translation steps necessary to get the data out, and instead be able to directly reason about the functioning of the domain itself.

### Stripe as inspiration
One source of inspiration for the design is the Stripe API ([docs](https://stripe.com/docs/api)). Their API is designed as if they publicly exposed their internal domain model, allowing external customers to directly hook into their own core domain. While I do not have an understanding of their technical implementation beyond the knowledge it is based upon Ruby, I am fairly sure their API relatively closely maps to their core domain as well. 

Directly coupling the domain to the API layer is not without risks though, as it makes changes more difficult. As the understanding of the core domain evolves, sometimes the need arises to refactor the model to more properly capture the meaning of an operation. One such thing can be seen in the Stripe docs as well when it comes to operations related to the [`Charges` api](https://stripe.com/docs/api/charges). [The operation to create a new charge had been deprecated](https://stripe.com/docs/api/charges/create), and instead they now refer to the [payment intents api](https://stripe.com/docs/api/payment_intents). In this situation it is clear how the evolution of their understanding of the core domain changed the way their software functions.

Now from a technical perspective this change could have been made in two ways:

1. The existing `Charges` api had been discarded in place. Everything works and still works in the way it does, though it is no longer the recommended way to do things.
2. The new `Payment Intents` api had been developed to be able to do everything the `Charges` api already had been able to do, and more. The old api would have internally been rewritten to use the new constructs, still using the old api for compatibility purposes.

## Designing for change
To be able to cope with the inevitable change to the domain layer we should take some measures to make this change easier in the future. There is a broad variety of architectural principles available which can help with this, each solving different problems. Let me outline some of these tactics here:

- Do not **ever** expose the internal representation of the aggregate to the outside world. 
    - The internal representation is private, and keeping it private helps changing your understanding of the domain model without breaking external dependents.
    - To expose information about the aggregate one can create a snapshot (or use a view model), mapping the internal domain model to something which others may actually create a dependency on. As this is merely a mapping it will be fairly straightforward to update these in case of breaking changes _(and helps to keep private information private)_.
- Event sourcing helps to decouple the way information is stored from the actual representation of the information (through the aggregate). This allows one to more easily change the internal understanding of the data to fit an evolving understanding of the data.
- The inputs to the domain (`Commands`) and the outputs of the domain (`Events`) should be considered as well.
    - When using event sourcing techniques, events can generally only be added to. Consider this when designing events, and feel free to discard these in place. Even after having discarded them they will keep carrying the same semantic meaning.
    - As a command represents an operation against the domain one can freely change whatever is happening inside the domain as long as the outputs remain stable. When making signficiant changes this might mean the need to fake a certain output while swapping out the internal implementation of the domain.
- Do version your APIs, especially so if they are publicly accessible!
    - With versioning in place one can explicitly model an agreement around the support term of an API.
    - With proper versioning in place one can create a compatibility layer mapping one operation to another. For inspiration see [this blog post on API versioning by the Stripe team](https://stripe.com/blog/api-versioning).

With these considerations in place it should be achievable to create a domain abstraction which has lots of wiggle room to evolve in a way which does not break existing implementations. If backwards incompatible changes are really necessary however there are still ways to cope with this, and have ways to provide backwards accessibility in a way which does not interfere with the independent evolution of the core domain.