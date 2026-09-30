FROM ruby:3.3-slim

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 8080

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:8080", "config.ru"]