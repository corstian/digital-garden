---
title: "The state-problem with MVVM"
date: 2025-08-03
---

While the experience developing applications using the MVVM model is generally pleasant, there is one pitfall revolving around state. This problem revolves around the question about how to update local state in a way which matches the mutations as had been applied by the data source, ideally without having to re-initialize the view.

## Scenario #1
Consider the situation where an API exists, and there is a client solely communicating with said API for interactions. After an operation, how can the client know it represents the correct state without doing a refetch?

There are different sorts of responses a web-api can return:

- Just a response code indicating the success of the operation 
- Event(s) representing the changes which had just been applied
- An object representing the current state of the mutated objects

Evidently merely returning a status code does not give much information as to the current state of the data-store, and isn't of much use in here. The second approach of returning events representing the change gives very specific and detailed information as to what had just happened, and can be useful, but generally encourages implementing different flavours of domain logic at least twice. One situation in which this is permissible is when domain logic itself can be redistributed across clients, and can be used to consolidate client state with the events which had been received. Arguably this comes with its own challenges as to be able to redistribute the core domain, as well as the question whether one actually wants to redistribute their whole domain. For companies this might as well mean their whole internal processes become transparent, which is more of a strategic decision than anything else.

The last case where the mutated objects are returned fully is perhaps the most straightforward approach of them all. It strikes a balance about having to refetch a full view worth of state and only updating one of the items contained. Additionally the information is handed to you, rather than you having to request it, which further reduces the opportunity for error. This approach works especially well with a normalized cache, where objects are retrieved from and updated at a local cache.