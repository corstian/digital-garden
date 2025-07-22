---
title: Skyhop
layout: default
toc: true
date: 29-11-2023
---

# Skyhop

Skyhop is the name of a flight analysis platform I had been developing over a couple of years. Although the platform itself went nowhere, I consider the effort I put in to be a valuable learning experience. This both on a technical level as well as a sociotechnical level.

At the time I had been flying gliders. The intent of the platform had been to collect information and fully automate the flight log. This from the perspective of the airfield, the aircraft and the pilot all at the same time. These three are all required to maintain logs about flight movements, as per regulations.

## Overview
The way this platform worked was by ingesting realtime data about aircraft movements, comparable with FlightRadar. This 'raw resource' was then processed - in real time - to figure out what was happening, and record flight movmements as they happened.

### Flight Analysis
This had been one of the first feats of my software development career. At the time I managed to track thousands of aircraft in real time and record their flight log. This had primarilly been a technical achievement. At its peak the system had been processing about 4000 position updates each second. [The code I wrote to be able to do so is available on GitHub.](https://github.com/skyhop/flightanalysis)

### Application Development
The second part of this project involved not only collecting all this information, but also showing it back to the users. It was this part of the application for which I had to develop an API, a frontend application and whatever more was necessary. At the time I was working on this I was only slowly making progression. Part of this was due to lacking knowledge about proper software architecture. Other parts involved an unclear direction.

The interesting aspect of this project is that this learned me how to effectively design web applications. It required me to find creative solutions from an UX perspective in order to let certain flows make sense. Perhaps the best work in this area had been delivered in a single form. One for which I needed about three iterations to get right, and which condensed several pages into one.

### Algorithmic work
The collection of these vast amounts of flight information allowed other fascinating opportunities as well. Among these are several algorithms I had built to extract more flight information from the position information:

- The localization of a broken weak link based on flight information
- The automatic completion of flight records by combining position information of the pilot with position information from the aircraft
- The estimation of a gliders mass based on its position

## Resulting work
Although the platform itself went nowhere, much of the experience gained throughout this project can be recognized in other projects I had been working on. Much of what I learned about software architecture can be found in the [`Whaally.Domain`](https://github.com/whaally/domain) library.

## Future plans
If my capacity allows me to do so I might one day try to revamp this project, and make it more sustainable for the long run. Taking the things I learned in the process, removing the cruft that had accumulated over the years and delivering the useful bits. Until that time this project remains an artifact from my own learning process.
