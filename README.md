# Student Knowledge System
   ![image](https://github.com/Knowledge-Ninjas/student_knowledge_system/assets/143157800/2dd6f3bf-c9d9-4b38-b50e-8769b464c694)

A Ruby on Rails web application for instructors to manage student records across courses. You can access our web application by clicking on the link below and creating a new account using your TAMU email id.

(https://sks-tamu-dev-e3e46be25a57.herokuapp.com/)

## Getting Started (From Zero to Deployed in ... Some Amount of Time)

## Initial Setup, Installing Dependencies

* Be in your dev machine, e.g. a fresh VPS or container (recommend Ubuntu 20+ with >=2 GB RAM)
* Fork this repository: [fork it](https://github.com/philipritchey/student_knowledge_system/fork)
* Clone your fork: `git clone git@github.com:YOU/student_knowledge_system.git`
* `cd student_knowledge_system`
* Install rbenv with ruby-build: `curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash`
* Reload profile: `source ~/.bashrc`
* Update your system and install rbenv: `apt-get install update && apt install rbenv`
* Install ruby 3.1.3: `rbenv install 3.1.3`
* Set ruby 3.1.3 as the local default version: `rbenv local 3.1.3`
* Install bundler: `gem install bundler`
* Configure bundler to skip production gems: `bundle config set --local without 'production'`
* Install dependencies: `bundle install`
* Install Nodejs: `apt-get install nodejs`
* Setup the database: `rails db:migrate`
* Prepare the test database: `rails db:test:prepare`

## Running the Tests

* Run cucumber tests: `rails cucumber`
* Run rspec tests: `rails spec`
* Assert that all tests are passing.  if they are not, find out which are failing and fix them and/or contact the previous team for help in fixing them.  possibly, the failing tests are themselves invalid and can be safely skipped?

## If you want to run the application for local testing following the steps below, if you want to get it deployed to Production skip below to the Production Ready steps.

## Getting the Application Development Ready

* Create google oauth2 client id:
  * [Go to google cloud apis & services](https://console.cloud.google.com/apis)
  * If you've never been here before, you'll need to make a project first and congifure your oauth consent screen
    * Make the project internal
    * Only fill in the required fields:
      * Name: Your app's name
      * Email: Your email
      * Authorized domains: Your apps domain, E.g. `appname.herokuapp.com`. For development purposes just specify the existing app name `sks-tamu-dev-e3e46be25a57.herokuapp.com`
      * Developer contact info: your email
  * Go to credentials, then click create credentials at the top and select Oauth client id
    * Application type: Web application
    * Name: Your app's name, E.g: sks-tamu
    * Authorized redirect uris, Add: `http://localhost:3000/auth/google_oauth2/callback` and `http://127.0.0.1:3000/auth/google_oauth2/callback`
    * Take note of the Client id and Client secret
* Remove encrypted credentials that you cannot decrypt: `rm -f config/credentials.yml.enc`
* Create and edit new credentials: `EDITOR=nano rails credentials:edit`
  * Add google oauth client id and secret
    ```
      GOOGLE_CLIENT_ID: ...
      GOOGLE_CLIENT_SECRET: ...
    ```
  * Save and exit: `Ctrl+X`, Press Y and Enter.
* It may take about 5 minutes for the effects to take place
* Run the web application locally using: `rails server`
* Create a new account using your TAMU email id and have fun :). 
* Do leave us some feedback if you find any difficulties in following along or for other queries at our email id's below.

## Getting the Application Production Ready

* Install heroku cli: `curl https://cli-assets.heroku.com/install-ubuntu.sh | sh`
* Login to heroku: `heroku login -i`
  * `username: <your username>`
  * `password: <your API key>`
    * [get your API key from your heroku account](https://dashboard.heroku.com/account)
* Create an app on heroku: `heroku create [appname]`, where `[appname]` is an optional name for the app
* [Create an s3 bucket](https://s3.console.aws.amazon.com/s3/buckets)
* [Create iam role for app to access s3 bucket](https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1)
  * Take note of the access key id and secret access key
  * Create access policy: in your iam s3 user, under permissions, click add permission, then create inline policy
    * Choose `s3` as the service
    * Specify the actions allowed:
      * `ListBucket`
      * `PutObject`
      * `GetObject`
      * `DeleteObject`
    * Specify bucket resource ARN for the ListBucket action: click add ARN to restrict access
      * Put name of your s3 bucket in the bucket name field
    * Specify object resource ARN for the PutObject and 2 more actions:
      * Put name of your s3 bucket in the bucket name field
      * Click any next to object
    * Click review policy at the bottom
    * Make sure it looks right and then create it
* In `config/storage.yml`, make syre `region` and `bucket` fields match yourt bucket's region and name
* Create google oauth2 client id:
  * [Go to google cloud apis & services](https://console.cloud.google.com/apis)
  * If you've never been here before, you'll need to make a project first and congifure your oauth consent screen
    * Make the project internal
    * Only fill in the required fields:
      * Name: your app's name
      * Email: your email
      * Authorized domains: your apps domain, e.g. `appname.herokuapp.com`
      * Developer contact info: your email
  * Go to credentials, then click create credentials at the top and select oauth client id
    * Application type: web application
    * Name: your app's name
    * Authorized redirect uris, add: `https://appname.herokuapp.com/auth/google_oauth2/callback`
    * Take note of the client id and client secret
* Remove encrypted credentials that you cannot decrypt: `rm -f config/credentials.yml.enc`
* Create and edit new credentials: `EDITOR=nano rails credentials:edit`
  * Add AWS access key and secret (the iam s3 user access key id and secret access key)
    ```
      aws:
        access_key_id: ...
        secret_access_key: ...
    ```
  * Add google oauth client id and secret
    ```
      GOOGLE_CLIENT_ID: ...
      GOOGLE_CLIENT_SECRET: ...
    ```
  * Save and exit: `ctrl+o`, `ctrl+x`
  * Take note of the master key in the console
* Save master key to heroku as config var (for security): `heroku config:set RAILS_MASTER_KEY=...`
* Configure email account for sending emails (e.g. one-time magic links)
  * Use gmail (because why not?)
  * [Create an app password](https://support.google.com/mail/answer/185833?hl=en)
* Set sendmail config vars on heroku
  * `heroku config:set SENDMAIL_USERNAME=the email address you just created/configured`
  * `heroku config:set SENDMAIL_PASSWORD=the app password you just created`
  * `heroku config:set MAIL_HOST=https://appname.herokuapp.com`
* Stage changes: `git add .`
* Commit changes: `git commit -m "ready to push to heroku"`
* Deploy to heroku: `git push heroku master`
* Run migrations on heroku: `heroku run rails db:migrate`
* Seed database on heroku: `heroku run rails db:seed`
* Open the app on Heroku and poke around the deployed app
* Don't forget to also push to your github repo: `git push`

## How to run the tests

We have already verified above the tests are running, the commands to run the tests and generate a coverage report are:

* Run cucumber tests: `rails cucumber`
* Run rspec tests: `bundle exec rspec`

You can verify the results by checking the coverage report located under the coverage folder (index.html).

## Our Team

Please leave us a message to any of our emails below for queries regarding the Project.

### Knowledge Ninjas - CSCE 606 2023B - Fall 2023

* [Shubham Mhaske](mailto:shubhammhaske@tamu.edu)
* [Vivek Narukurthi](mailto:vivekn@tamu.edu)
* [Akshit Bansal](mailto:akshit.bansal@tamu.edu)
* [Shresth Kushwaha](mailto:shresth.kushwaha@tamu.edu)
