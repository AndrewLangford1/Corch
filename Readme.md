#Corch
## Jenkins Automation tool for Cloud Orchestration
###to run:
1. Install RVM with ruby 2.2.1
2. Run: gem install bundler 
3. Run: bundle install 
4. Update config/config.yml
5. Configure /config/config.yml docker and kubernetes attributes
6. Run: rake run
7. point your browser to {hostname}:5000
8. check out /routes folder for usage of this api. should be used with the UI found at https://github.ibm.com/aavetis/CloudOrchUI
##Docker
### This application is packaged with a dockerfile that will also build and run the app inside an ubuntu container.
##Jenkins/Docker/Kubectl server
###pieces needed:
1. A server with jenkins installed. Currently no form of authentication on this server is supported.
2. Jenkins plugins: Git plugins (to pull code)
3. the linux user jenkins must be allowed sudo priveledges
4. Docker cli must be installed on the jenkins server.
5. Your docker registry must be added to the known hosts files and must be declared an insecure registry. 
6. the linux user Docker must be given sudo priveledges. 
7. Kubectl (for kubernetes) must be installed on this server, and the kubernetes master server must be added to the list of known hosts on it. 

