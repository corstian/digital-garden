---
title: "HTTP API best practices"
date: 2025-08-03
---

HTTP API best practices
=======================

This is a living document collecting some great principles about API design I have encountered throughout the years. Not all of these principles are fully attainable on a shoestring budget, but one can aspire to. Take this as a source of inspiration, not as a dictate.


## API Versioning

**Do's**
- Use a timestamp for versioning. Year and/or month and/or day dependent on your rate of change
- Create a new API version for backward incompatible changes
- Explicitly require an API version request
- In absence of a version request, either fail the request or fallback to the oldest available API version

**Do not's**
- Implicitly assume a client uses the latest version if it lacks a version request

**Examples**
[Stripe has a great approach to maintaining backwards maintainability.](https://stripe.com/blog/api-versioning) They primarily maintain the current version of the API. In order to achieve backwards maintainability the older API versions are projected from the current version. This allows the API and data model to evolve independently from the older API versions. It has distinct maintainability benefits over for example copying API handlers to a new directory, or something similar.

It should be noted that - at least for dotnet - there are no examples or frameworks about how such aproach would work in practice.


## URI Structuring


## API Responses

**Do's**
- When an operation has side-effect; return the mutated object(s)
- Be explicit with HTTP error codes
- Return links to other resources whenever possible (in conjunction with plain object identifiers)

**Do not's**
- Return HTTP 200 OK with a body containing a failure reason
- Solely return a status code for POST operations


