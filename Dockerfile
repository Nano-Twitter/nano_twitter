FROM ruby:2.6.0

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
# RUN bundle update --bundler
RUN bundle install --system

ADD . /app
RUN bundle install --system

EXPOSE 80

# # If you do not have a bin/web wrapper file, create one or update this command
# RUN chmod a+x bin/*
# CMD ["bin/web"]
CMD ["bundle", "exec", "rackup", "-p", "80", "--host", "0.0.0.0"]