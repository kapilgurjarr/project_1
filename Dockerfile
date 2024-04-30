# Pull base image 
From tomcat:8-jre8 

# Maintainer 
MAINTAINER "devopsguftgu@gmail.com" 
COPY ./var/lib/jenkins/workspace/project1/webapp/target/webapp.war /usr/local/tomcat/webapps
