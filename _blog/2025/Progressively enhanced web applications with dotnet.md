Progressively enhanced web applications with dotnet
=====================================

In a previous post I had been railing against the architectural decisions underpinning Blazor. These architectural decisions make it unnecessarily hard to develop a progressively enhanced (that is primarily server side rendered) web application. It is for this situation that the more old-fashioned Razor templates are more suitable. Rather than acting as a full application framework, Razor acts more as a templating library instead leaving more room for 


In a previous post I had been writing about Blazor and how it is not my tool of choice for the development of a progressively enhanced web applications. Rather than using Blazor I personally prefer the use of more classic Razor templates for the more explicit separation of concerns between server and client. In this post I will go through the structure of a Razor web application. The focus of this post will be on delivering a minimal server rendered web application.


Over the years as a developer I have acquired a liking to simple HTML based server applications. Over the course of my career I have seen the attitude sway from "HTML isn't a programming language" to "React has poisoned the web", and everything which came between. Having had experience developing single page applications I must now admit there is barely a more simple way to develop web applications than to have them rendered on the server side, and using plain HTML for all interactivity.

Behind this seemingly simple interaction model lies remarkable power. While I have taken a personal preference to building seemingly unpolished applications, the clarity which comes with a well-defined interaction model between client and server allows for a remarkably expressive handling of posted information.
