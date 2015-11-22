FROM ruby:2.2.3

RUN mkdir /pingbot

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /pingbot
WORKDIR /pingbot
CMD ["rails","server","-b","0.0.0.0"]

