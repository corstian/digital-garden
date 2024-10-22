---
title: "DevExpress Shenannigans"
layout: default
toc: false
date: 2024-09-12
---

# Some DevExpress Shennanigans
The documents contained here are personal notes shared with the wider community. This means that there is no affiliation with DevExpress other than that I am in a position to use this framework. This by no means should be interpreted as an endorsement by myself of DevExpress, nor vice-versa.

Please note that due to my prior experience and contexts I carry several strong opinions regarding technical architecture and development processes. These opinions come for free with the documents contained here, and have been formed and applied in a context not necessarilly similar to the context you are operating in. It is for this reason you should be careful implementing the suggestions made in these pages in your own situation. In short my position on XAF can be summarized as follows; "awesome for scaffolding user interfaces; but keep it the hell away from my data".

## Background
Let me slightly expand on the prior statement. The context I am coming from is one where we were dealing with a lot (1B+ records) of complex information, with the business logic concisely expressed in a domain model which could independently function and be subjected to tests. With the XAF framework coupling the user interface straight to the database I see multiple problems arising which I have personally solved a long time ago. It is for this reason that when I am in a position to use XAF, I tread carefully with data access, discard existing solutions involving Entity Framework or XPO, and roll my own. This allows me to treat solemnly as an user interface scaffolding framework, achieving the same if not higher development velocity. This of course is only applicable if or when you're working with complex data. No such thing applies if you're only working with CRUD operations.

## Topics
The high-level background of my own work with XAF involves two distinct areas of work:
- The implementation of a custom UI frontend (not being WinForms or ASP.NET powered)
- The use of XAF in a mobile scenario and the implementation of an offline synchronisation solution

While I cannot go in-depth on the concrete implementations of this technology for obvious reasons, I can elaborate on the background of this work as it relates to the XAF framework. Writings around here should be interpreted in one or both of these scenarios.
