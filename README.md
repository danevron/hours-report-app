# hours-report-app


A simple hours report application for Klarna TLV.

This application is customized for the Klarna TLV office. But, with small modification, can be used by any company or organization.

## Objectives
Provides a simple, fast and fun way for:

1. Employees to fill working hours, vacations, sick leave etc.
2. Employees to submit travel expense reports.
3. HR to manage the procees and send the data to for salary calculation.          

## workflow

The workflow that the application is intended for is the following:

1. Admin invites new Employees by filling some basic information.
2. Employees gets an invitation e-mail and join using their Google (work) account.
3. Admin creates a monthly report.
4. Employees are filling their hours at their free time.
5. Admin sends reminders to users to submit their hours.
6. Users submit their relevant timesheet.
7. Admin closes the report and sends it for salary calculation.

### Expense report workflow

1. Employee creates an expense report by filling flight times and destination + adding expenses.
2. Per Diem is calucalated, exchange rates are extracted automaticly.
3. Employee submits the report for approval.
4. Admins are notified to review and approve by email.
5. All approved expense reports are aggrageted and the final sum gets added to the monthly hour report sent to salary calculation.  


## Main components

* Authetication system using Google (Klarna is using Gmail as an email provider).
* Company vacations are automaticly added to employees timesheets - Admins maintain a Google calendar.
* Personal vacations, sickness days and army days extraction from personal Google calendar using labels.
  
  To use, create a **full day** event and add `@hrs` to the title along with one of the following:
  * **PTO** - Vacation day (e.g. "Dani PTO in Mexico @hrs")
  * **Half PTO** - Half of a vacation day (e.g. "Dani Half PTO @hrs")
  * **Army** - Army reserve day (e.g. "Dani Army Reserve @hrs")
  * **Sick** - Sick day (e.g. "Dani out sick @hrs")
* 10Bis data extraction (User and password for 10Bis needed).
* Emails sending.
* Online currency exchange calculation using the EU central bank.

## Installation 

### Ruby

The Ruby version in which this project should run is defined in `Gemfile` file. In order to use this, you should
install the latest version of RVM, which as of this writing get be installed by running:

    curl -sSL https://get.rvm.io | bash -s stable

after installing rvm, it will instruct you to install the appropriate ruby version when you cd into the application directory.

### Postgresql


In our production and development PostgreSQL databases. In order to run the application locally you need to install a PostgresSQL server in your laptop. To install it:

    brew install postgresql

Postgres has a long command as we need to pass in the locations so I've taken to creating an alias to shrink all this down to simply `pg`.

For zsh use:

    echo 'alias pg="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log"' >> ~/.zshrc

For bash use:

    echo 'alias pg="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log"' >> ~/.bash_profile

To start the DB server run:

    pg start

### Redis

The application uses Redis as a DB for [Sidekiq](http://sidekiq.org/).
To install Redis:

	brew install redis

	# Add Redis to launchctl to let OS X manage the process and start when you login, this will use the default config from /usr/local/etc/redis.conf

	ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist

### Oauth2 with Google

To set up authentication via Google, you will need to acquire your own google key and secret.

Follow the steps [here](http://edralph.wordpress.com/2012/04/14/omniauth-google-oauth2-strategy-google-key-and-secret/).

To understand more about the topic you can read [this](http://blog.myitcv.org.uk/2013/02/19/omniauth-google-oauth2-example.html) nice blog post.

### PhantomJS

We scrape the 10Bis site to extract the data(because they don't have an API).
In order to perform that, you need to install PhantomJS

To install PhantomJS.

    brew install phantomjs

Or just upgrade it if you already have an older version

    brew upgrade phantomjs

### Environment Variables

We are using the [Dotenv](https://github.com/bkeepers/dotenv) gem to load confidential configuration settings that are not stored in our git repository.

Environment variables needed for the application:

* APPLICATION_CONFIG_SECRET_TOKEN: your-secret-token
* HOLIDAYS_CALENDAR_ID: identifier-for-the-company-vacations
* GOOGLE_KEY: application-key-for-google-omniauth
* GOOGLE_SECRET: application-key-for-google-omniauth
* PERSONAL_CALENDAR_MARK: string-which-identify-the-personal-calendar-event
* REDIS_URL: url-to-redis
* SIDEKIQ_PASSWORD: sidekiq-ui-password
* SIDEKIQ_USER: sidekiq-ui-username
* TENBIS_PASSWORD: 10Bis-password
* TENBIS_USER: 10Bis-user-email

## Initial setup

### Authorization

We use [the_role](https://github.com/the-teacher/the_role) gem for Authorization.

You will need to create one admin user manualy.

First, lets create the admin role:

	bundle exec rails g the_role admin

Next, lets invite a user by creating an invitation in the console (use your own email):

	Invitation.create(recipient: "dan.evron@klarna.com", sender: "dan.evron@klarna.com", employee_number: 10, tenbis_number: "8939")

Now, start the application, go to localhost:3000 and sign in using your Google account.

Give the new user admin permissions:

	User.first.update( role: Role.with_name(:admin) )

Check your admin Role:
  Role.with_name(:admin)

Due to a bug in the_role it isn't always populated with the correct data. if "the_role" attribute is an empty hash do the following:
  admin_role_fragment = {
    :system => {
      :administrator => true
    }
  }

  Role.with_name(:admin).update_attribute(:the_role, admin_role_fragment)

Now you should have a fully functional development environment!!

## Deployment (for the TLV application)

This application is currently hosted on Heroku.
In order to be able to deploy you should complete steps 1-3 in this [quickstart](https://devcenter.heroku.com/articles/quickstart)

Next, to link to the existing Heroku app:

	git remote add heroku git@heroku.com:hours-report.git

Now you should be able to deploy by running:

	git push heroku master

