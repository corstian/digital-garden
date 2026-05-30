# Introduction

Before starting off, let me assert I am not a sysadmin. I wanted to become one when I was younger, but then reality caught up and I became a software developer instead. Over the course of my career I grew more accustomed to Linux systems. First as server systems, and later as my daily driver as well. Most of the systems I managed back then were just one-off projects. Systems I managed to install - to get working even - but that was about it.

Over time the question about how to manage more systems than just my own became increasingly relevant. The first part of this puzzle had been found in a declarative and immutable system. The implications of these two words - declarative and immutable - are that the system is configured from a single file, and from a single file only. Changes cannot be made from outside these files. The first system I set up this way had been a work project, and it stuck.

The issue I originally had with Linux had been about accumulating cruft. Things you install and forget about. Tools you put in different locations, symlinks you make to get stuff working. Workarounds hacked together, configuration files littered all over. Over time this all started adding up and the result of it had continuously been the same. A system which felt like your own, but without any recollection of how it got there, nor how it worked. It made fixing issues difficult, which I why I generally put that off in the first place. Each time you'd need to change some thing it'd require you to figure out where the thing was in the first place. Not even to consider things which seemingly randomly broke down.

The nice thing about working with nixos is that most of these issues seems to vanish. Sure there's the configuration for which you'll need to take the time to tweak to your needs and your liking, but you know where to find these. This comes with a bonus of being able to put your system under version control, treating it just like another software project.

The last thing before writing this document had to do with a broken down macbook. There were important documents on there - no backups, and soldered on memory. This had been the straw which broke the camels back. Something had to be done here for once and for all, and so it happened.

# Goals
This document outlines my understanding of managing a home network with a number of Nix(OS) machines. This network contains a variety of machines; a server, at least three laptops, and a desktop.

While each of these machines requires a different configuration - depending on their intended function as well as their intended users - they also have a common set of shared infrastructure. This shared infrastructure consists of encryption, backups, VPN/mesh networking, some security measures and access to shared devices such as printers. Each of these machines must be configured such that they can fulfill their intended function.

At the same time my appetite to become a full-time system administrator - especially at home - is close to zero. Ideally I want to spend zero effort on ongoing maintenance. At the same time maintenance is nearly inevitable and whenever such is necessary I want it to take it as little effort as possible.

Before we're diving into all these specifics I want to give a high-level outline of what it is we're going to do, what components we're going to use, why we're going to use them and how these fit in with one another. Feel free to read this document in its entirely, or pick out the specific aspects interesting to you.

# Overview
On a high level the NixOS ecosystem consists of three distinct parts working together. It's the [Nix language](https://nix.dev/tutorials/nix-language.html), the [Nix Package Manager](https://search.nixos.org/packages) and the [Nix Operating System](https://nixos.org). To follow this guide you should have a basic understanding of the nix language. The rest will follow along.

The way we will be managing the home network is by writing a set of configuration files using the Nix language. Depending on how these configuration files are set up they can be used both with the Nix Package Manager (which can be installed on operating systems besides NixOS), or with NixOS directly. Using the package manager on other operating systems is outside the scope of this document.

The configuration files themselves govern two distinct areas; hardware and software. Hardware herein is likely machine-specific, whereas the software can be generic but not necessarily so depending on user preferences. A complicating matter here is the interface between hardware and software - one found in hard-drive partitioning and file systems.

Closely related to file systems are both encryption and backups. While [full-disk encryption](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system using LUKS) is always an option, alternatives exist both on the filesystem level, as well as on the [userspace](https://en.wikipedia.org/wiki/User_space_and_kernel_space) level. This ties in to the available backup options. The naive option here is to copy files to an external drive. There are however - depending on filesystem - faster and more versatile options available.

The difficult part here becomes balancing user privacy with convenience of administration. Systems and their uses are continuously evolving and like that it is only a matter of time before a systems' configuration needs to be updated. The times of walking around with usb-thumb drives are over, and instead we'd want to be able to remotely update a systems configuration. This requires far-reaching administrative access to a machine, so how can we grant ourselves this convenience without also granting ourselves the ability to snoop on end-users?

To make remote deployment work you'd need to have network access to the machines you're deploying to. This isn't always the case - either I'm out of the house and get a franctic signal about how something isn't working or it's the other way around. To deal with this we'll set up a mesh-vpn over these devices for them to stay connected to one another. This has one additional benefit in the sense that all DNS traffic can be tunneled over a pihole or blocky instance.

As the cherry on top there are personal user profiles on these machines. How do we tailor the machines to each individual user's liking? One likes the look and feel of macos, while the other doesn't care about the operating system as long as they can play minecraft.

Last but not least there is a thing about parental controls. While I generally like to have a hands-off approach, I do acknowledge sometimes it is necessary to set healthy boundaries. While the technical implementation of these boundaries is a last resort, I want to retain the ability to set up and enforce these boundaries - the two being screentime and network restrictions. The internet is inherently predatory, and it is irresponsible and unhealthy to dump the youth straight in and let them figure out things on their own.

# Infrastructure
...
