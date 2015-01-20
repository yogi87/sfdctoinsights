## SFDC -> Insights

This tool is build to help export Log data from SFDC into New Relic Insights. 

## Getting Started

1.  Setting up your environment. 
  a)  Download and install at mininum Ruby version 2.0.
  b)  Download and install at mininum Rails version 4.0.
  c)  Install Postgres. 

2.  Clone the application. 

3.  Unzip and navigate to the application root.

4.  Run the bundle command to install required gems. 

5.  Set your Salesforce App ID and Salesforce App Secret in the /config/application.rb file. This can be generated from your Salesforce Account. 

6.  Run "rails server" to start up the application and "rake jobs:work" in development to start delayed_job (background processing).

7.  Before polling for data, besure to update the application settings to add your New Relic Insights App ID, API Key, Insights Event Type, and polling interval.

 ## Moving to Heroku

 1. Follow diretions from [heroku deployment guidelines] (https://devcenter.heroku.com/articles/getting-started-with-rails4#deploy-your-application-to-heroku).

 2. Besure to scale Heroku Workers to atleast 1 by running "heroku ps:scale worker=1" and starting delayed jobs in the background. 

