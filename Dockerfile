# Select ubuntu as the bse image
# FROM masoo/ubuntu-2204-ruby:3.1.1
FROM seapy/ruby:2.6.1

# Install nginx, nodejs and curl
RUN apt-get update -q
RUN apt-get install -qy nginx
RUN apt-get install -qy curl
RUN apt-get install -qy nodejs
RUN apt-get install -qy --force-yes libpq-dev
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN chown -R www-data:www-data /var/lib/nginx

# Install foreman
RUN gem install bundler
RUN gem install foreman
RUN gem install rails

# Add configuration files in repository to filesystem
ADD config/container/nginx-sites.conf /etc/nginx/sites-enabled/default

# Add rails project to project directory
ADD ./ /rails

# set WORKDIR
WORKDIR /rails

ENV RAILS_ENV production
ENV PORT 8080

# bundle install
RUN /bin/bash -l -c "bundle install --without development test"

# Publish port 8080
EXPOSE 8080

# Startup commands
CMD bundle exec rake db:create db:migrate assets:precompile && foreman start -f Procfile