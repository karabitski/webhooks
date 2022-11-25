FROM ruby:2.7.6

RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends build-essential \
      curl git sqlite3

COPY Gemfile* /usr/src/app/

WORKDIR /usr/src/app

ENV BUNDLE_PATH /gems
RUN bundle install

COPY . /usr/src/app/

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
