Analytics in a JS-less world
==================

This post relates to my recent explorations on the development of progressively enhanced frontends, with a focus on the usability of web-applications without javascript. It is in the context of user-tracking and ad-delivery that the absence of javascript really uncovers what it is primarily being used for.

Javascript libraries are often injected on the client to be able to track user-activity and/or for ad-delivery. For most websites these two go hand in hand. While it is totally possible to collect server side analytics, I suspect this is not often done for the following reasons:

- Client side tracking yields more and more detailed data
- Server side tracking requires deep technical integration; either in the application itself, or in supporting infrastructure

The analytics and ad-tech industry has come up with "innovations" allowing the fingerprinting of individuals based on thousands of different aspects; most notably being the environment they use; that is screen resolution, browser, operating system, and much, much more. The remainder can be extracted based on behavioural analysis. The main problem here - in my humble opinion - is not so much the analytics part (more on that later). The problem here is that this information is aggregated from across the internet, with the goal of extraction: more attention and ultimately more money. Hence the close ties between analytics and ads.





A primary use-case for javascript in todays world is the inclusion of user-tracking in client-applications. While client-side user tracking is no longer possible with javascript disabled, one can still track users from the backends of their applications. After all all interactions with the applications eventually hit the server. This provides the opportunity for remarkably powerful telemetry and usage insights. Combined with event-sourcing and the logging of so-called wide-events this would result in telem

The JS-less world is less than ideal for adtech. Limiting yourself to work without it limits one to the extent data can be collected about individual users. And while this is the case, there are still remarkably powerful tracking mechanisms for collecting usage information in a JS-less world. Personally I would compare it with the telemetry coming from the JWST. While there is no camera providing a visual feed of the state of the satelite, there is a plethora of sensors providing a rather accurate and complete overview over the state of the device. It is much the same way for a HTML-only frontend. While you cannot track individual users, you can still see how they are using your application by tracking what operations they execute. Combine this with an event-sourced domain and the collection of wide-events, and you'll have telemetry and usage information on your application most analytics providers would be jealous of.
