IPv6 is your friend for small scale continuous deployments
========================================

In the pursuit of software quality, your CI/CD pipeline is one of the defining aspects on your success in continuously delivering working software. Nowadays much of this complexity is abstracted away behind build and deployment tools, though more often than not these involve more complexity than necessary.

For small scale deployments the bar however isn't nor doesn't need to be all that high. Fancy aspects such as rolling zero downtime deployments are not necessary. With decent built software the effective downtime might even be less than a second which will be barely noticeable by its users. Do not tread too lightly on this topic whatsoever. While it is easy to build scalable software, it is far easier to build a monolith running on a single system. In practice this means deploying the build artifacts to the target machine, and restarting the process. It is getting the artifacts to the target machine which is the difficult part.

Or so I thought.

For years I have be repulsed by IPv6 for its complexity, their illegible IP addresses, and a lack of understanding how existing concepts translated to the IPv6 paradigm. In the traditional IPv4 sense, getting access to a specific machine had been a complex undertaking. In case no public IPv4 address could be directly bound to the machine it often required setting up port forwarding, NAT hole punching, proxy servers and more of the like. No more whatsoever with IPv6. With the absolutely ridiculous number of addresses available each and every thing on this earth can have its own publicly accessible IP address. And this is an awesome thing for continuous deployment.

Sure, sure, if we're building a product I'm sure we still want it to be accessible through a traditional IPv4 address, for accessibility purposes. As part of our 