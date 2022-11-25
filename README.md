# Webhooks

![CI Status](https://github.com/ayarotsky/webhooks/actions/workflows/status_checks.yml/badge.svg?branch=master)

The most simple project management tool in the world.

It doesn't even have authorization and UI 😱.

![](diagram.png)

## Dependencies

- ruby-2.7.6
- SQLite
- Docker

## Installation

Run the following commands.

```bash
bundle install
bundle exec rails db:drop db:setup
```

Let's make sure everything is ready.

```bash
bundle exec rspec
```

## Run in Docker

```
# Run the web app
docker compose up

# Create the DB
docker compose run --rm web bundle exec rails db:drop db:setup

# Let's make sure everything is ready
docker compose run --rm web bundle exec rspec
```

## Assignment

- Add token-based authentication to the existing API.
- Cover the changes with tests.
- Ensure that the new code follows the existing Rubocop rules.
- Extract all business logic from controllers and models into a service layer.
- Write documentation for all new methods and models.
- You can use any gem to solve any part of the assignment. Provide a detailed comment
  explaining why you chose a certain gem.

You're good to go. Happy coding 🤘!

![](happy-coding.gif)
