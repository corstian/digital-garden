---
title: "Building a custom UI frontend for XAF"
date: 2024-09-12
toc: false
layout: default
---

# Building a custom UI frontend for XAF
XAF is a proprietary library for the scaffolding of the user inferface for line-of-business applications written in .NET. The primary use-case for this framework is to offload UI considerations to this framework such that it is able to construct an application. Working with a different set of constraints however I had encountered a situation where it became necessary to swap out the supported frontends (Windows Forms & asp.net) for another UI stack, leading me through the internals of the XAF framework.

## XAF internals
XAF can best be visualized as a manifold containing a number of ports the end-user-developers can hook into. Inside of the manifold however everything is seemingly connected to one another.

**The `XafApplication`**
Whether we're dealing with a WinForms application or an ASP.NET implementation, XAF always starts out with an application instance. This is where everything gets wired up together. The startup process exists of the following steps:

1. Instantiation
2. `Setup`

During the setup step the application pulls together all the different modules and sourced it had found, extracts the domain objects, data objects, controllers, actions, views and whatever more there is. This generally happens through the modules which are registered, which XAF then rolls up into a single comprehensive application model. Most of the definition from how the application itself behaves comes from one or more `Model.xafml` files (whether or not stored in a database, that is).

Some of the generalized behaviour the application should be able to offer comes from two primary objects registered with the `XafApplication` implementation:

- a `ShowViewStrategy`: responsible for managing different windows
- a `LayoutManager`: responsible for rendering components to the external UI stack


