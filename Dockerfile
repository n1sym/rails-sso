FROM ruby:3.0.2-alpine

WORKDIR /myapp
COPY Gemfile Gemfile.lock /myapp/

RUN apk add --no-cache -t .build-dependencies \
    alpine-sdk \
    build-base \
    mysql-client \
 && apk add --no-cache \ 
    bash \
    mysql-dev \
    nodejs \
    tzdata \
    yarn \
 && gem install bundler:2.0.2 \
 && bundle install \
 && apk del --purge .build-dependencies

COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]