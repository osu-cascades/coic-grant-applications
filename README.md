# COIC Grant Applications

This project is in partnership with the Central Oregon Intergovermental Council (COIC) and is aimed at enabling COIC to better utilize the data collected from Covid relief fund applications for communicating the level of impact they've made on the community and analyzing what underserved demographics might be better served in future outreach programs.

This app allows the user to upload csv files of of small business data collected during an application round and provides an interface to search the resulting database based on common business and owner demographic information to help quantify the amount of aid provided to different districts and demographics in Central Oregon. 

## Expectations

This is a Rails 5.x app with Ruby \~2.7, PostgreSQL, and AWS for storage.

After cloning this repository and `cd`ing into it, get up and running with:

`bundle install`
`rails db:setup`
`rails s`

## Development

There are a few steps to get up and running in development.

### Customize `.env`

* `DATABASE_URL_DEV`
* `DATABASE_URL_TEST`

See _.env.example_ for a complete list of expected environment variables.

## Testing

This app is using minitest / Rails default tests. Run the suite with:

`rails test`

Run system tests with:

`rails test:system`

Note: There is a _Guardfile_ should you wish to use guard.

## Production

There is a staging and production environment hosted by Heroku.

```
heroku git:remote -a coic-grants-staging
git remote rename heroku staging
heroku git:remote -a coic-grants
git remote rename heroku production
```

By renaming the remotes, you can then deploy with

```
git push staging
git push production
```

Configure env vars in staging and production:

* `RECAPTCHA_SITE_KEY`
* `RECAPTCHA_SECRET_KEY`
* `AWS_S3_KEY`
* `AWS_S3_SECRET`
* `AWS_REGION`
* `AWS_S3_BUCKET`

Note: See _.env.example_ for a complete list of expected environment
variables that need set in both staging & production environments.

&copy; 2020 Central Oregon Intergovernmental Council. All rights reserved.
