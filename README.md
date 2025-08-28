# Data Ethic Framework

This is a proof of concept application.

It takes content defined using GOVSPEAK markdown in YAMLS files stored
at `data/content` and display it as HTML pages.

The content document have a position attribute which is used to place
them in a basic navigation system.

The application also defines a set of questions within YAMLS files
stored at `data/questionnaires`, and generates a question and answer
journey based on that data.

## Local installation
This is a Ruby on Rails application and requires Ruby and PostgesSQL installed.

- Clone this application to your local environment
- cd into the application root
- run `bundle` to install the required ruby gems
- run `rails db:create` and `rails schema:load` to set up the database
- run `rake javascript:build` to set up the JavaScript environment
- run `rake dartsass:build` to set up SASS

You should then be able to run a local instance of the application using `rails s`

## Continual Integration (CI)
The CI pipeline for this application are run via github actions.

The following CI elements can be run locally before deployment.

### Tests
To run the test locally use the command `rspec`

### Linting
Use Rubocop to check the Ruby code of this application locally. The following
command will both find any problems and attempt to fix them: `rubocop -A`

### Vulnerability testing
Use the command `brakeman` to locally run a vulnerability test on the code

