---
title: "DevExpress XAF"
date: 2024-09-12
layout: default
toc: false
---

# DevExpress XAF
The DevExpress eXpress Application Framework, XAF for short, is a proprietary library lauded by enthusiasts for the speed with which line of business applications can be built.

The framework primarily targets Windows forms, asp.net web forms and Blazor, with the option to scaffold an API. This framework attempts to proivde the glue between a database and an user interface. Generally the development process is mostly focussed on the definition of the data model, and after that the definition of the layout. Due to the way this framework abstracts the data store all of this can possibly be achieved with no involvement of the IDE whatsoever, practically amounting to a no-code solution.

## High level architecture
From a high-level overview XAF attempts to glue many different concerns together; including but not limited to data persistence, security, customizeability, localization and user experience. From an architectural perspective this leads to the XAF framework functioning as a manifold, with predefined ports for the end-user-developers to interact with; what happens inside the manifold does however remain opaque.

## Considerations
First off; this approach to developing line--of-business applications suits many, and that is fine. From my experience however there are some noteworthy considerations when using this framework.

### Anemic domain models
This framework is primarily designed for use in CRUD applications. This means there is a straightforward mapping between the data model and the UI. If each data model has the following operations it is considered to be feature complete; 

1. List all available objects
2. Create a new object
3. Update an existing object
4. Delete an existing object

CRUD applications can only grow so complex before one starts departing from this paradigm. It is at this point that one starts building special purpose functions for use against the data model. At this very point the shortcomings of the CRUD first/only approach become apparent.

To deal with this very issue I suggest refactoring a XAF application in such a way that it does no longer bear responsibility for the persistence of data objects anymore. This way an additional abstraction is introduced between XAF and XPO/EF Core which takes the data and ensures it is properly stored. Having XAF deal with view models against a proper domain model improves the testability of the domain layer, ensures one is free to structure the code in whatever manner is suiteable in the current situation, but also allows one to continue benefitting from the UI scaffolding functionality XAF provides.