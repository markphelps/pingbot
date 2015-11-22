FROM ruby:2.2.3

RUN mkdir /notifier

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /notifier
WORKDIR /notifier
CMD ["foreman","start", "-p", "4567"]

