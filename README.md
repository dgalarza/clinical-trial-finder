# Clinical Trial Finder

[![CircleCI](https://circleci.com/gh/mwenger1/clinical-trial-finder/tree/master.svg?style=svg)](https://circleci.com/gh/mwenger1/clinical-trial-finder/tree/master)
[![Code Climate](https://codeclimate.com/repos/580ce59aefbc1b5742003dfd/badges/bd0e46bb5202ab1376bf/gpa.svg)](https://codeclimate.com/repos/580ce59aefbc1b5742003dfd/feed)

## Project Goal

Clinical trials are a key part of advancing medical knowledge but they face
challenges:

* [85% of clinical trials finish
  late](https://www.foundationforpn.org/research/clinical-trials/) due to
  difficulties enrolling participants
* Nearly [one-third of trials never
  begin](https://www.foundationforpn.org/research/clinical-trials/) after
  failing to recruit a single participant 
* Only [3% of cancer patients participate in trials, with 80% not even aware of
  their clinical trial
  options](http://www.forbes.com/sites/judystone/2015/01/06/how-can-we-encourage-participation-in-clinical-trials/#14e3d9376dd5)

All of these challenges lead to a drug development process that [takes 10-15
years](http://www.cancerresearchuk.org/about-cancer/cancers-in-general/cancer-questions/how-long-does-it-take-for-a-new-drug-to-go-through-clinical-trials).

For individuals interested in participating in a
clinical trial, there is [ClinicalTrials.gov](http://clinicaltrials.gov/), a
government website with a database of all active clinical trials in the
United States. This site does not meet the needs of potential volunteers as:

* The search functionality is not intuitive
* It is not disease specific
* It caters to research audiences and does not speak to an individual on the
  fence about participating
* It is not well promoted
* There isn't a way to find out about future trials as they become available

Disease foundations and nonprofits have developed strong communities of people
who want to donate their time and money to finding cures, run marathons and
create donation pages. These organizations are able to attract candidates that
are a great fit for clinical trial participation - between diagnosed patients
and their loved ones. This open-source platform makes it easy for any disease
foundation or nonprofit to bring the rich clinicaltrials.gov data to their
communities.

Organizations like the [National Brain Tumor Society](http://clinical-trial-finder-staging.herokuapp.com/)
have already started using the platform to promote trial participation to their
communities.

### Syncing With ClinicalTrials.gov

To make sure the trials displayed are accurate, the platform downloads and syncs
with ClinicalTrials.gov multiple times per day via a scheduled
[rake task](https://github.com/mwenger1/clinical-trial-finder/blob/master/lib/tasks/scheduler.rake).


## Supporting the Project

There are many ways to help.

* Introduce us (michaelwenger27 (at) gmail.com) to organizations that would be
  interested in using the platform
* Help us improve the platform by sharing feedback and ideas for new
  functionality
* Spread the word
* [Contribute and help us work on new features](#contributing)


## Contributing

Join our
[contributors](https://github.com/mwenger1/clinical-trial-finder/graphs/contributors) and
help accelerate drug development!

### Guidelines

The [Issue Backlog](https://github.com/mwenger1/clinical-trial-finder/issues) is a great
place to start to see the roadmap and what needs to be worked on.

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

### Setting Up Your Environment

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

```
  % ./bin/setup
```

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

Running the importer for trials requires geocoding thousands of sites. This
takes time and exceeds the free account. If you wish to avoid this and use test
data, run:

```
  % ./bin/seed_database
```

If you are interested in seeding the database with real trials from
clinicaltrials.gov:

* Create a Developer Account with [Google](https://developers.google.com/maps/documentation/geocoding/intro)
* Update the GOOGLE_GEOCODING_API_KEY environment value with your new API Key
* Run the importer by running:

```
  % rake scheduler:import_trials_from_clinicaltrials_gov
```

After importing data, you can run the application using [Heroku Local]:

```
  % heroku local
```

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

You can now view the application at
[http://localhost:5000/](http://localhost:5000/)

## License

Clinical Trial Finder is Copyright © 2016 Michael Wenger. It is free
software, and may be redistributed under the terms specified in the [LICENSE
file](/LICENSE).
