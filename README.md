# Trial-match

[![CircleCI](https://circleci.com/gh/mwenger1/trial-match/tree/master.svg?style=svg)](https://circleci.com/gh/mwenger1/trial-match/tree/master)


## Project Goal

For individuals interested in participating in a
clinical trial, the [ClinicalTrials.gov](http://clinicaltrials.gov/) website
does not fully meet their needs.

* The search functionality is not intuitive
* There isn't a way to find out about future trials as they become available

This project makes it easy for disease foundations
such as the [National Brain Tumor Society](http://braintumor.org/) to bring the
rich clinicaltrials.gov data to their communities.

## Import Service

To make sure the trials displayed are accurate, the platform downloads and syncs
with ClinicalTrials.gov multiple times per day. [View Import
Logs](http://trial-match-staging.herokuapp.com/import_logs)

## Contributing

Pull requests are welcome!

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [Heroku Local]:

    % heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

Geocoding and importing trials is time intensive. The best way to seed your
database is grabbing a snapshot of production. You can do this by:

```
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d trial-match_development db/seeder_database.dump
```

