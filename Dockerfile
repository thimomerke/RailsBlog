FROM ruby:2.6.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs 
RUN apt-get install sqlite3 -y
RUN apt-get install coffeescript gawk g++ gcc make libreadline6-dev -y
RUN apt-get install libssl-dev libyaml-dev libsqlite3-dev autoconf libgmp-dev libgdbm-dev -y
RUN apt-get install libncurses5-dev automake libtool bison pkg-config libffi-dev -y
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs
RUN mkdir /railsapp
RUN echo 'gem: --no-document' >> ~/.gemrc
EXPOSE 3000
WORKDIR /railsapp
ADD Gemfile /railsapp/Gemfile
ADD Gemfile.lock /railsapp/Gemfile.lock
RUN chown -R root:root /railsapp/Gemfile.lock
RUN chmod 777 /railsapp/Gemfile.lock
RUN bundle install
ADD . /railsapp
RUN rails g migration add_slug_to_posts slug:string:uniq
RUN rails generate friendly_id
CMD bundle && rake db:create db:migrate db:seed && rails s