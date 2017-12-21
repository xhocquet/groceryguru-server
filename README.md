# Grocery Guru - Server

[![Hakiri Security](https://hakiri.io/github/xhocquet/groceryguru-server/master.svg)](https://hakiri.io/github/xhocquet/groceryguru-server/master) [![Code Climate](https://codeclimate.com/github/xhocquet/groceryguru-server/badges/gpa.svg)](https://codeclimate.com/github/xhocquet/groceryguru-server)

Grocery Guru is a tool to maximize your grocery spending.

Simply upload your receipts, fill in the missing data, and Grocery Guru will tell you where you could be saving!

### Current Features
- Upload and OCR receipt images into data for Grocery Guru
- Convenient tools to update and fix incorrect data
- Stats page describing spending habits by item
- Insights into potential savings
- Item pricing trends

### Planned Features
- Improved image processing for higher success rates
- Fuzzy text processing and improved results for less manual labor
- Advanced insights into grocery habits by time, location, and food groups
- Insights based on real-time store data, including sales and promotional offers

### Current Stack
- Ruby on Rails
- SQLite3 (dev) / PSQL (prod)
- ElasticSearch

### Major Dependencies
- [Tesseract](https://github.com/tesseract-ocr/) (Text recognition)
- [RMagick](https://rmagick.github.io/) (Image modifications)
