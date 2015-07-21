#Corch
## Jenkins Automation tool for Cloud Orchestration
###to run:
####1. 
 -Install RVM with ruby 2.2.1
####2. 
-Run: 
-gem install bundler
-bundle install
####3.
-point config/jenkins_config.yml attributes to the jenkins installation. Currently it is pointing towards jenkins running locally on localhost on port 8080. **currently jenkins authentication is not supported **
####4.
-Run:
-ruby server.rb
####5.
-point your browser to {hostname}:4567
####6.
-check out /routes folder for usage of this api.

