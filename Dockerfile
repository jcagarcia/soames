FROM ruby:2.7.2-alpine3.12 as base

RUN apk update \
 && apk add --no-cache  \
 && apk add openjdk8  \
    build-base  \
    ruby-dev

ENV APP /opt
WORKDIR $APP

COPY Gemfile soames.gemspec $APP/

FROM base as test

COPY lib $APP/lib/
COPY spec $APP/spec/
RUN bundle install -j 10 --quiet

FROM base as release

COPY lib $APP/lib/
COPY .gitignore README.md $APP/
RUN bundle install -j 10 --quiet --without development test
