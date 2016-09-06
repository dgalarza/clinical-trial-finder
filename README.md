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

## Contributing

Pull requests are welcome!

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
heroku pg:backups capture --app trial-match-staging

curl -o latest.dump `heroku pg:backups public-url --app trial-match-staging`

pg_restore --verbose --clean --no-acl --no-owner -h localhost -d trial-match_development latest.dump

rm latest.dump
```

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production
