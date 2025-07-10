A critical look at Blazor
================

Blazor seems to have become the tool of choice for people developing web applications with .NET. Having experimented a bit with Blazor, I decided not to pursue it any further, for reasons I will lay out here.

## My goals
As a professional I want the software I develop to be accessible - that is - to work on devices other than my own. My goal is there is to make this software work on the smallest common denominator. For web development this means building for devices on slow networks, with small screen sizes, incredibly slow processors and little memory. It is for this reason that I appreciate the concept of progressive enhancement, dynamically offering additional capabilities tailored on the device the application functions on, but also ensuring it works on any device it is served on. The basis therefore is a web application, rather than a single page application. Not having JavaScript on device is not an excuse to have a broken application.

It is for this reason that I started out playing around with Blazor SSR. This way it is basically like a fancy page renderer, putting HTML in all the right places and serving that to the clients. This works.

Where things became more difficult had been the lifecycle. Where the essential components of the web includes forms, Blazor had difficulties distinguishing multiple forms from one another, and required a bit of work to get this to work properly (wrapping a form in a component, using a `FormMappingScope` element to wrap that one again to set a unique name)