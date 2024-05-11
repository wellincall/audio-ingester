FROM ruby:3.3.1

WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app

RUN bundle install

COPY . /app

CMD ["ruby", "audio_parser.rb", "input_files"]
