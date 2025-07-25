---
date: 2025-07-10
title: "A critical look at Blazor"
---

A critical look at Blazor
================

Blazor seems to have become the tool of choice for people developing web applications with .NET. Having experimented a bit with Blazor, I decided not to pursue it any further, for reasons I will lay out here.

As a professional I want the software I develop to be accessible - that is - to work on devices other than my own. My goal is there is to make this software work on the smallest common denominator. For web development this means building for devices on slow networks, with small screen sizes, incredibly slow processors and little memory. It is for this reason that I appreciate the concept of progressive enhancement, dynamically offering additional capabilities tailored on the device the application functions on, but also ensuring it works on any device it is served on. The basis therefore is a web application, rather than a single page application. Not having JavaScript on device is not an excuse to have a broken application.

It is for this reason that I started out playing around with Blazor SSR. This way it is basically like a fancy page renderer, putting HTML in all the right places and serving that to the clients. This works, arguably pretty well. Data can be pulled in through one of the lifecycle events, such as `OnInitializedAsync`.

Things became more difficult developing interactivity into the application. Working without client side javascript, one is dependent on the more rudimentary constructs such as forms, which is exactly where things became more difficult. The dynamic creation of multiple forms proved difficult as each form required a unique name. Getting this to work required extracting the form into a custom component, doing some parameter binding, and more of the like. Here is a small example of what that involved:

```cshtml
@foreach (var id in new { Guid.NewGuid() })
{    
    <FormMappingScope Name="@id">
        <DeleteItem Id="@id" />
    </FormMappingScope>
}
```

With the `DeleteItem` component looking like this:

```cshtml
@code {
    [Parameter] public Guid Id { get; set; }

    [SupplyParameterFromForm] RemoveProduct Model { get; set; } = new();

    protected override void OnParametersSet()
    {
        Model = new()
        {
            Id = Id
        };
    }

    private async Task OnRemoveProduct()
    {
        // .. do stuff ..
    }
}

<EditForm OnSubmit="OnRemoveProduct" Model="@Model">
    <input type="hidden" name="Id" value="@Model.Id"/>
    <input type="submit" value="delete" />
</EditForm>
```

Awkwardness erupted as such delete operation had been invoked. While the form handler could be invoked, the page itself still kept showing the previous state.

The reason for this only becomes apparent when taking a closer look at the various lifecycle events being invoked during page render. As it turns out, upon form submission, the whole page is recreated from scratch to discover the various form bindings, and to be able to associate the form submission logic with the form it came from.

This hints at an underlying design decision which is rather important to understand the functioning of Blazor. Rather than treating HTTP as a stateless protocol - like it had traditionally been considered - the Blazor team had attempted to overlay it with a stateful layer. The benefit of this approach is that this allows one to indiscriminately mutate any state accessible. From a software QA perspective the explosion of the possible state-space - and accompanying increase in complexity - is something to avoid.

To serve the correct content after the aforementioned form submission, one needs to make a tradeoff between complexity and performance. Once the POST operation is sent to the server, the server requires at least one database roundtrip to recreate the form and handle the POST request itself. From there onwards one can choose to create an event handler to re-fetch the content from the server after the post operation had been completed. This is a pretty failsafe way to ensure one is serving the correct state, although at the cost of at least 2 database roundtrips for a simple application. This has the potential to easily double response times. If one prioritizes response time one must alter the locally available state to match the supposed state after the mutation. While this is way faster than a database roundtrip, this usually leads to a significant increase of complexity, as well as the risk that the local state no longer matches the global state.

The problems do not stop here. If the global state had changed in the meantime - meaning Blazor could not reconstruct the original page markup - this might very well mean that the original form could not be retrieved anymore. It's these framework level deficiencies which are incredibly difficult to work around in a generic manner, making it difficult to deliver truly solid and fault-tolerant applications.

This is one of the main reasons I consider Blazor to be unsuitable for progressively enhanced applications.


The new direction of Blazor becomes even more apparent when we start considering how it functions in interactive mode; that is when the client supports JavaScript, and is able to establish a real-time connection with the server. In this situation Blazor no-longer suffers from the problems mentioned before, but instead starts storing application state on the server. The mere assumption a stable internet connection is available at all times makes me nervous. This assumption is one which in the real world - that is outside of the cushy offices of tech workers - cannot hold. Most notably in public transit; where public internet is slow, where during a cross country trip coverage is spotty, and where ones velocity is directly correlated with latency.

Taking a step back once again to take a look at Blazors high level architectural intentions it becomes clear that it tries to be a front-end framework, but it is inseparately coupled to a server, and that is a shame. It is by attempting to hide this boundary - by abstracting it away - that it becomes so much more difficult to reason about what Blazor is actually doing, and where it is doing that. Initially I was rather enthusiastic about the idea that the server would maintain an open connection with the client. This - as I thought - would facilitate a new level of realtime interconnectedness and responsive applications. This initial enthusiasm however made way for more skepticism, as best practices around accessibility and performance seem to have been thrown out of the window.


It might very well be the case that I am missing the point of this new technology. One of the key takeaways I had learned from my decade in application development is that the quality of a front-end application starts with the design of the API it is to communicate with. The worse the quality of the API, the more the frontend team will need to step up to compensate for it to deliver a qualitative application. Additionally having an application become tolerant to connectivity issues opens up a whole different can of worms about things to consider. Starting with synchronisation, local caching, responsiveness and more. Blazor does not particularly help addressing these two aspects. It does nothing to help create a qualitative interface between the client and the server, and if anything muddies this boundary. Additionally Blazor is not particularly helpful in remediating connectivity issues. While I am not saying it is impossible to create great experiences using these tools, they are not helping either. It is for this reason that I would rather use Razor templates for server side rendering, and roll my own hand-written javascript to help on the client-side wherever relevant.
