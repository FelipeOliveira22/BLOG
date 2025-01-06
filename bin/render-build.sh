#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Use a variável DATABASE_URL do ambiente
export DATABASE_URL=$DATABASE_URL

# Rodar migrações
bundle exec rails db:migrate
