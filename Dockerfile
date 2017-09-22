FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y imagemagick tesseract-ocr tesseract-ocr-eng
RUN mkdir /GroceryGuruServer
WORKDIR /GroceryGuruServer
ADD Gemfile /GroceryGuruServer/Gemfile
ADD Gemfile.lock /GroceryGuruServer/Gemfile.lock
RUN bundle install
ADD . /GroceryGuruServer
EXPOSE 3000
