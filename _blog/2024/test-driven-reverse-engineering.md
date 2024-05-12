---
title: "Test driven reverse engineering"
date: 2024-05-12
slug: "test-driven-reverse-engineering"
toc: false
---

Working a highly complex and volatile environment, your process might be the only thing able to guide you through. Over the past few weeks I have been working a complex reverse engineering task providing little reference material to gauge progress upon. The only reference in this task itself had been the process.

Problematic for these sort of reverse engineering tasks is that a black-box approach might work, but that the unknown-unknowns are simply too great to be acceptable. Following through you're working a process without any perspective on the remaining time necessary to achieve the intended goal. As this is how I started out I quickly figured I'd need to break open the black box. Not merely to satisfy my own curiosity of how it had been functioning, but as a way to get a sense of perspective as well. How much was there really that we had been working with? How much time would be required to achieve our goal?

Just lifting the lid of this system alone had been a task, the time for which could not easily be quantified beforehand. To provide some predictability in this uncertainty, there were two principles which had been a great reference as to our progress: doing small iterative steps, and employing a test-driven approach to this reverse engineering task. Yes that's right, test driven reverse engineering.

Taken together these two aspects provide a rather powerful paradigm. The iterative feedback cycles allow you not to get wound up in a complex web of contributing factors, while the test driven approach gives a sense of progress.

This in itself requires you to start small. What is the smallest step you can take to succesfully reverse engineer the payload? Often this smallest possible step itself is comprised of even smaller steps. In this case transformations of syntax trees, by themselves resulting in incorrect code, but combined together having the potential to yield significant results. Once again it is remarkable how quickly small operations add up to really complex behaviour.

Having managed to acquire this deeper insight into the payload not only did we succeed in getting a fresh perspective on the complexity of the task, but also did we set up a test suite which can be used to validate newer versions of said payload against. Ultimately then the failing assertions state exactly what assumptions no longer hold, thus helping maintain a certain velocity in the analysis of newly evolved strains of said payload.
