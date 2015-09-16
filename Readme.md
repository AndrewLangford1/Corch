#Corch
## Jenkins Automation tool for Cloud Orchestration
###to run:
1. Install RVM with ruby 2.2.1
2. Run: gem install bundler 
3. Run: bundle install 
4. point config/config.yml jenkins attributes to the jenkins installation. Currently it is pointing towards jenkins running locally on localhost on port 8080. **currently** **jenkins** **authentication** **is** **not** **supported**
5. Configure /config/config.yml docker and kubernetes attributes
6. Run: rake run
7. point your browser to {hostname}:5000
8. check out /routes folder for usage of this api. should be used with the UI found at https://github.ibm.com/aavetis/CloudOrchUI

