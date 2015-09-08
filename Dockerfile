FROM ubuntu:trusty
MAINTAINER tcnksm "https://github.com/aslangfo" (https://github.com/aslangfo%27) 
# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y --force-yes build-essential wget git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

RUN apt-get install ruby-dev -y

RUN gem update
RUN gem install bundler

ADD . /root/sinatra
WORKDIR /root/sinatra
RUN ls; bundle install
EXPOSE 5000
CMD ["rake","run","/root/sinatra"]