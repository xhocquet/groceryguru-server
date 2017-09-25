# Grocery Guru - Server

Grocery Guru is a tool to maximize your grocery spending.

Simply upload your receipts, fill in the missing data, and Grocery Guru will tell you where you could be saving!

### Current Features
- Upload and OCR receipt images into data for Grocery Guru
- Convenient tools to update and fix incorrect data
- Stats page describing spending habits by item
- Insights into potential savings

### Planned Features
- Improved image processing for higher success rates
- Fuzzy text processing and improved searching for less manual labor
- Advanced insights into grocery habits by time, location, and food groups
- Insights based on real-time store data, including sales and promotional offers
- Pricing history and trends of items

### Current Stack
- Ruby on Rails
- SQLite3

###Goal Stack
- Ruby on Rails
- PostgreSQL
- Redis
- ElasticSearch

### Major Dependencies
- [Tesseract](https://github.com/tesseract-ocr/) (Text recognition)
- [RMagick](https://rmagick.github.io/) (Image modifications)

# Ubuntu server setup commands
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
rvm install 2.4.2
rvm default 2.4.2
gem install bundler
sudo apt-get install -y imagemagick libmagickwand-dev
sudo apt-get install -y tesseract-ocr
sudo apt-get install -y libpq-dev
```
