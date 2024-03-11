---
title: Air Quality and Tomato Plant Growth 
layout: default
usemathjax: true
toc: true
---

# Air Quality and Tomato Plant Growth

In the past I had been developing Internet of Things (IoT) infrastructure for air quality measuring devices. These devices were designed for use in the agricultural industry, with one of them being developed for use in greenhouses.

It was in this company that my responsibilities extended far beyond software development and operations, and - among other things - included data analysis and a bit of research. It had been in this capacity that I was also involved in a project with the goal to optimize the yield of tomato plants through the optimization of air quality.

## Background
To figure out how air quality impacts the growth of a tomato plant we dove into existing literature to come up with a basic understanding of such a plant. The idea is that when it comes to air quality there are four primary growth regulators:

- [Temperature](https://en.wikipedia.org/wiki/Temperature)
- [Humidity](https://en.wikipedia.org/wiki/Humidity)
- [Carbon dioxide ($$CO_2$$)](https://en.wikipedia.org/wiki/Carbon_dioxide)
- [Photosynthetic Active Radiation (PAR)](https://en.wikipedia.org/wiki/Photosynthetically_active_radiation)

It is suggested[^1] that out of these four factors there is at least one inhibiting plant growth. Increasing the supply of this resource would thus result in faster plant growth.

## On the inner workings of tomato plants


## Finding optimal $$NO_x$$ concentrations
Prior research suggested low $$NO_x$$ concentrations cause certain plants to show a growth spurt. The levels at which this ought to happen as well as the relative size of this growth spurt had never been quantified before.

As it turned out we could reliably observe a growth spurt at a narrow concentration of $$NO_x$$. This band exists roughly between 20 and 50 ppb. It is at these $$NO_x$$ concentrations that we can see plant growth increase significantly, regardless of the four factors mentioned before. To give visibility to this phenomenon we took the [electron transport rate (ETR)](https://en.wikipedia.org/wiki/Plant_stress_measurement) as a measure of plant efficiency. This rough trend can be seen irregardless of the ETR values, even though plants seem to become slightly more susceptible to $$NO_x$$ poisoning at higher transport rates.

![](/assets/CA3112385A1.png)


This insight leads us to an ironical truth. Far more often than not, growers injecting $$CO_2$$ into their greenhouses were poisoning their crops with $$NO_x$$, thus negating the positive effect $$CO_2$$ should have had on plant growth. This problem arises due to the way that the $$CO_2$$ had been acquired; through the burning of natural gas in the [combined heat and power system (CHP)](https://en.wikipedia.org/wiki/Cogeneration). Practically the $$NO_x$$ is a side effect from an inefficient combustion process, in an improperly tweaked or maintained CHP system.

It is for this reasons that the growers using liquid $$CO_2$$ for injection do not have this same problem, and are in a better position to see an increase in crop growth as a direct result of $$CO_2$$ injections.

---


[^1]: [basisprincipes van Het Nieuwe Telen](https://www.kasalsenergiebron.nl/content/docs/Het_Nieuwe_Telen/De_basisprincipes_van_Het_Nieuwe_Telen.pdf): _An interesting integrated conceptualization about how to manage a greenhouse, and with that the health of the crop._