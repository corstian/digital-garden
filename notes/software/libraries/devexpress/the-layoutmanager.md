---
title: "What is the LayoutManager?"
toc: false
layout: default
date: 2024-09-12
---

# What is the XAF `LayoutManager` class?
XAFs own documentation on the `LayoutManager` is marginal, which isn't all that weird considering it is only fulfilling a supporting role in the rendering of a layout. In essence it should do only a single thing: to return a single control. Practically this that this component is responsible for wrapping controls in situations where more than one is passed. Depending on the UI framework used it may be enough to put a control inside of a grid or a stack panel.

## Where does it come from?
When building a new `XafApplication` imnplementation you'll need to override the abstract method `CreateLayoutManagerCore`. Without this set your XAF application will be unable to render components to the screen. The `WinApplication` - for example - is able to use one of two different implementations: either the `WinLayoutManager` or the `WinSimpleLayoutManager`.

> The `simple` argument on the `CreateLayoutManagerCore` seems to be there only for convenience for the Windows implementation. This argument does not impact anything on the web platform.

An additional bit of interesting information is that multiple instances of the `LayoutManager` may exist at any given point in time. Upon instantiation of a [`CompositeView`](https://docs.devexpress.com/eXpressAppFramework/DevExpress.ExpressApp.CompositeView) it retrieves a new instance of the `LayoutManager` through the `XafApplication.CreateLayoutManager` method. 

## On its internal behaviour
When deriving from the abstract `LayoutManager` one is expected to override a single method: `GetContainerCore`. This is the method which is expected to return only a single control. Do not let yourself be fooled though, as the controls to wrap should be retrieved from another method which is called: `LayoutControls`. From this place you can grab the controls you need and declare them as instance variables on the current `LayoutManager` implementation such that they can be accessed from the `GetContainerCore` method.

It should be noted that it is important to call the base implementation from the overridden `LayoutControls` method. Underneath it does some voodoo, ultimately to call the `GetContainerCore` method and return it's return value.
