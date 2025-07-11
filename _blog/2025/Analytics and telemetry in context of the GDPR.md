Analytics and telemetry in context of the GDPR
====

Both telemetry and analytics are important for assessing the functioning and usage of an application. The GDPR provides regulations governing what information may be collected for this purpose, and how it should be processed.

The regulatory text can be found [here](https://eur-lex.europa.eu/eli/reg/2016/679/oj).

This post acts mostly as a high-level reference. For details; refer to the regulatory text.

## Definitions
Lets start with a quick primer on the most important terms used:

*Personal Data*:
- "Information relating to an identified *or* indentifiable natural person"
- "by reference of an identifier such as"
    - Name
    - Identification number
    - Location data
    - Online identifier
    - Physical traits
    - Physiological traits
    - Genetic traits
    - Mental status
    - Economic status
    - Cultural identity
    - Social identity

*Processing*:
- Collection
- Recording
- Organisation
- Structuring
- Storage
- Adaptation or alteration
- Retrieval
- Consultation
- Use
- Disclosure
- Alignment or combination
- Restriction
- Erasure or destruction

## Principles
The processing of personal data ought to be based on the three principles of "lawfulness, fairness and transparency".

Data should only be collected and processes for explicitly specified legitimate [^1] purposes, and no further. Exemptions are made for archiving in the interest of public, scientific, historical or statistical purposes (See [Article 89](https://gdpr-info.eu/art-89-gdpr/)).

Data should be kept up-to-date. Care should be taken to ensure inaccurate data is either erased or rectified "without delay".

Personal data should be appropriately secured, and protected against unauthorized or unlawful processing, accidental loss, destruction or damage.

## Lawfulness of processing
Only if at least one of the following:

- Appropriate consent had been given
- Processing is necessary as part of a contract
- Processing is necessary as a legal obligation of the controller
- Processing is necessary to protect the interests of the data subject
- Processing is necessary for public interest or as part of "official authority".
- As part of "legitimate interest" *except* where overridden by the interests or fundamental rights and freedoms of the data subject

The two loopholes in here are contractual obligations (forcing the terms of service down ones throat), and the so called "legitimate interest". Unfortunately it is stated that "the processing of personal data for direct marketing purposes may be regarded as carried out for a legitimate interest". This gives the whole ad-tech industry a blanket waiver to collect PII for the purpose of serving targeted advertisements. Due to the invasive nature of ad-tech I would argue my personal right to privacy overrides their "legitimate interest".

> Is "legitimate interest" a placeholder for legislation meant to eventually yeet the whole adtech industry out of existence?


## Telemetry and Analytics
With those formalities out of the way it can 


[^1]: "Legitimate" meaning "in accordance with the law or established legal forms and requirements".