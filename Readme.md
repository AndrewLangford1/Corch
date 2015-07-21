#Corch
## Jenkins Automation tool for Cloud Orchestration
###to run:
 -Install RVM with ruby 2.2.1 \n 
-gem install bundler \n
-bundle install \n
-point config/jenkins_config.yml attributes to the jenkins installation. Currently it is pointing towards jenkins running locally on localhost on port 8080. **currently jenkins authentication is not supported ** \n
-Run: \n
-ruby server.rb \n
-point your browser to {hostname}:4567 \n
-check out /routes folder for usage of this api. should be used with the UI found at https://github.ibm.com/aavetis/CloudOrchUI

