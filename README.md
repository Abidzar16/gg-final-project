# Social Media Microservice

---

## Problem description

This repository containing server-side only social media application that can be used to share information with other people inside a spesific company. therefore, the usage of existing public social networks is prohibited.

---

## Prerequisites to test and run the application locally

1. Import the schema into local mysql database (filename: schema.sql)
2. create .env file based on .env.example, replace the value based on mysql server you used (username, password, host, port, database name)
3. run ```bundle install``` on the command line to install dependency needed to run project

---

## Instructions on how to run the tests suite and the application

### Run the tests suite

1. make sure you already fulfiling the prerequisites before
2. run ```rspec --format=documentation``` on the command line

### Run the application locally

1. make sure you already fulfiling the prerequisites before
2. run ```rackup -p4567``` on the command line
