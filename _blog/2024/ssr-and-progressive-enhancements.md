---
title: "SSR and Progressive Enhancements"
slug: 'ssr-and-progressive-enhancements'
date: 2024-05-30
toc: false
---

We all presumably know about the current state of the web. The average application suite used in workspaces contains at least 20 Mb of stuff which should be pulled in over the web, a minority of which we actually get to use. Sure enough there are reasons for this, and there will be an explanation for how this all came to be, though I'm not so much interested in covering this.

What I am interested in however is exploring how we can get back to the basics. To see if there are obvious ways we can simplify the digital products we are all building, and if, during this endeavour, we might be able to simplify the development process as well.

But before we dive in let's examine the current state of affairs. On the market there are a wide-variety of front-end development frameworks, among which React, Vue and Svelte. A general trend among these is that they all started incorporating server side rendering paradigms. This is useful for a number of things, among which most notably client side performance and accessibility. It is through adding this feature that these previously predominantly front-end frameworks started positioning them in a rather awkward place. Where previously there was a hard boundary between the client and the server, it now starts fading. Either that, or what had previosuly been exclusively a front-end framework, is now becoming responsible for both back end as well as front-end concerns.

This paradigm had not only been adopted by these javascript frameworks, but can also be seen with .NETs Razor project (now rebranded as Blazor). With Blazor however one additional factor at play is the interop between multiple languages and platforms.

The intent at the same time is not to bash on these platforms either. If these do in fact fit your needs, by all means go for it. However, to be able to determine what fits your needs, you will need to be aware about your needs in the first place, and this is where it often goes wrong. The result can generally be described as an additional mass of unnecessary complexity.

## Where do we place the boundary between the server and the client?
In its bare essence the internet isn't all that complicated, though at the sheer scale we're operating it today it's a miracle it works as well as it does. To facilitate the connection between a server and a client we're dependent on multiple protocol layers, among which [HTTP](https://en.wikipedia.org/wiki/HTTP) and [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol), the latternow being superseded by [QUIC _(Quick UDP Internet Connections)_](https://en.wikipedia.org/wiki/QUIC) FOR HTTP/3.

Historically these protocol layers also dictated the layers between systems, a paradigm which is evidently eroding nowadays. While in itself this is a good thing (most people are notoriously bad at developing API interfaces), this also results in a significant amount of added complexity not necessarily properly understood by the people using it. Whereas previously the distinction between client and server was more or less universally understood, this starts to fade and other paradigms start to emerge. This naturally results in more network chatter between both parties, with this chatter depending on the application itself for proper interpretation. This is particularly where this relatively new paradigm starts diverging from the traditional ways. Where previously one could rely on infrastructure (such as browsers) to deal with failure modes (think about form re-submissions), this now becomes a responsiblity of the application itself. While this gives application developers powerful new ways to deal with failure modes, we all know that failure modes are not the prime focus of the development of new apps.

Failures are best accounted for within infrastructure. Dealing with failures here allows one to prevent whole classes of failure modes alltogether, rather than having to focus on individual instances. This in turn facilitates app developers to focus solemnly on the happy paths, making them happy as well.

When one is not in a position to account for failure modes in a generic manner, the result will be a patchwork of individual and inconsistent fixes spread out all over the codebase. This in turn greatly increases the complexity of the application, thus the resources required to maintain and develop it as well.

The problem specifically arising then with these frameworks living on both sides of the protocol is that they make the transport layer in between an implicit implementation detail which the technology heavily relies upon. The implicit assumption held is that this connection will always be available, something which does not necessarilly hold. Also a thing which that whenever it can no longer be upheld, can not be as easily be changed for something more resilient either.

## How does progressive enhancement fit in here?
The promise behind progressive enhancements is that one begins with a rather barebones web application, one where the implicit assumptions are deconstructed to see what remains. Generally the most barebone application one could get away with is plain HTML, delivered over the HTTP protocol. Without further reliance on specific client capabilities, among which most notably javascript support, the speed and stability of the connection and the performance of the device itself as well.

With the rise of these frameworks involving both sides of the protocol it makes one wonder whether or not one could possibly use these frameworks to deliver a progressively enhanced experience. Primarily delivering a bare experience, further altering the functioning of the application based on client capabilities.

This promise already starts falling apart with your first exposure to Blazor. While the demo application still loads properly without javascript enabled, all of its functionality besides navigation ceases to function.

This touches upon a peculiar aspect of the development process for these applications. Rather than treating progressive enhancement as a first class citizen, it is generally considered to be merely an afterthought. This feels eerily simmilar to responsive design. To effectively apply responsive design principles you'll need to start with the mobile experience, and from there onwards scale out to larger screen sizes. The same seems to be the case with progressive enhancements. Focus on the minimum skeleton required for the app to function, and from there onwards gradually add more behaviour until you exhaust any and all relevant device capabilities.

## The development process
This change in the development process is in my opinion what makes this technology especially appropriate for startups looking to develop a web application. In fact, if one can make it useful enough without too much client-side schmuck, it should work with this schmuck as well. After all that's merely distraction. Personally I would even be in favour of leaving out styling as much as reasonably possible, thus leaving a barebones HTML application which interacts with the server. It results in a lean process with as much overhead shaved off as possible. It leaves the distractions out as well.

The unfortunate truth however is that so much of the conveniences we have come to known of the modern web rely on client side behaviour. This means that if one decides to go this route, they're mostly on their own and are required to reinvent the wheel.

> The implication of broadly adopting progressive enhancements is that one should be able to disable JavaScript, and be able to browse the web just fine. There is however an incentive for many parties not to facilitate this as it greatly reduces ones ability of end-user surveillance. The unfortunate truth is that nowadays without JavaScript, the web just is not accessible.

## Web frameworks for progressive enhancements
Where these libraries being both front and back end fit in rather well is the progressive enhancement side of things. But only, and only if these are no longer seen as 'frontend gone backend', but instead as 'backend first, frontend second'. These frameworks aim to lower the effort to switch between the frontend and the backend, which is a great thing. And so frontend development becomes more accessible to a backend engineer. But we must let go of the notion of a front end web application, and instead attempt to develop a fully function server side rendered web application, without any of the schmuck a frontend involves.

Ofcourse there are still areas where one is warranted in using a fully client side application. After all the web is no longer just the web. Over the years it had evolved to an application delivery mechanism as well. In cases where an application should also function while it is offline these sort of applications are awesome to have. Having an app which functions offline however requires a completely different architecture, which is not easily achieved only working with the simplistic notions of a backend and frontend applications. In this case it is easiest to think about both sides as being a distributed database, and all complexities related to keeping them in sync and consistent (consistency and partition tolerance from the CAP theorem, but not availability).

