#Corch
## Jenkins Automation tool for Cloud Orchestration
###to run:
1. Install RVM with ruby 2.2.1
2. Run: gem install bundler 
3. Run: bundle install 
4. point config/jenkins_config.yml attributes to the jenkins installation. Currently it is pointing towards jenkins running locally on localhost on port 8080. **currently** **jenkins** **authentication** **is** **not** **supported**
5. Run: rake run
6. point your browser to {hostname}:5000
7. check out /routes folder for usage of this api. should be used with the UI found at https://github.ibm.com/aavetis/CloudOrchUI

