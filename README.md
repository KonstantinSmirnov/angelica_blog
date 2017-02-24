# README

# .env file

## Database setup
DATABASE_USERNAME=
DATABASE_PASSWORD=

SECRET_KEY_BASE=

## Facebook share setup
FACEBOOK_APP_ID=

## Mailgun send letters setup
MAILGUN_API_KEY=
DOMAIN=
LETTER_FROM=

# Database.yml file
## PostgreSQL. Versions 9.1 and up are supported.

default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: angelica_blog_development


test:
  <<: *default
  database: angelica_blog_test

production:
  <<: *default
  database: angelica_blog_production
  username: angelica_blog
  password: <%= ENV['ANGELICA_BLOG_DATABASE_PASSWORD'] %>
