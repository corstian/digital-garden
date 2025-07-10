Progressively enhanced web applications with dotnet
=====================================

In a previous post I had been writing about Blazor and how it is not my tool of choice for the development of a progressively enhanced web applications. Rather than using Blazor I personally prefer the use of more classic Razor templates for the more explicit separation of concerns between server and client. In this post I will go through the structure of a Razor web application. The focus of this post will be on delivering a minimal server rendered web application.


Over the years as a developer I have acquired a liking to simple HTML based server applications. Over the course of my career I have seen the attitude sway from "HTML isn't a programming language" to "React has poisoned the web", and everything which came between. Having had experience developing single page applications I must now admit there is barely a more simple way to develop web applications than to have them rendered on the server side, and using plain HTML for all interactivity.

Behind this seemingly simple interaction model lies remarkable power. While I have taken a personal preference to building seemingly unpolished applications, the clarity which comes with a well-defined interaction model between client and server allows for a remarkably expressive handling of posted information.

## On tracking
The JS-less world is less than ideal for adtech. Limiting yourself to work without it limits one to the extent data can be collected about individual users. And while this is the case, there are still remarkably powerful tracking mechanisms for collecting usage information in a JS-less world. Personally I would compare it with the telemetry coming from the JWST. While there is no camera providing a visual feed of the state of the satelite, there is a plethora of sensors providing a rather accurate and complete overview over the state of the device. It is much the same way for a HTML 