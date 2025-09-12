---
title: "MVVM"
date: 2025-08-03
---

MVVM
====

The MVVM model is one approach to give structure to a front-end application. The MVVM model does so by seperating the Model, View and ViewModel from one another, with these components incidentally also making up the acronym "MVVM". Therein the model part represents the source of the data; be it a database, an API or whatever source you get your information from. The view is about how the UI looks like, while the viewmodel is what information and operations are available in the view.

## Benefits
This separation of concerns has several benefits. In the first place is the immediate benefit of a clear separation between view related logic and logic related to information contained in the view. To protect this separation one has to remember that a view is allowed to refer to the viewmodel, but the viewmodel is not allowed to know about the view. A more long-term benefit of this approach is that it allows one to switch out the frontend technology (the views) while maintaining the overall structure of the application (the viewmodels). This can be beneficial either if there are multiple implementations of the same application, for example on the web, iOS, Android, desktop or some terminal app. A rather long term benefit manifests here when the UI technology in use had been deprecated or outright abandoned. Something which happens especially often on the Microsoft stack, with JS frameworks, or in a lesser extent on mobile platforms as well.

## Challenges
Getting a demo up and running using MVVM is relatively easy. Getting an application into production is hard. One pervasive reason for this is state management. Essentially this boils down to the question about how you can ensure correct state is shown in the application after a mutation or operation had happened. The naive solution here - which is one used by default on the web - is to refresh all information from scratch (this is what makes HTML only web apps so incredibly simple to develop). A more advanced approach here is to take the result of the operation and manually patch the locally held data to reflect the changes.

This however will only get you so far, and is a shortcut to a bug-riddled application with state mismatches between client and server, or more generally between presentation and data-source. This requires one to know about the inner-functioning of business logic or domain logic, and recreate this in the viewmodels used. While this works, this is a subtle duplication of rather important logic. The result is often that the core domain logic is changed, but the client applications remain blisfully unaware and thus start presenting incorrect information.

