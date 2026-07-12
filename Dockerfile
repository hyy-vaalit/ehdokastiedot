# syntax=docker/dockerfile:1

# Development/test:  see compose.yaml
# Production:        docker build --target production -t ehdokastiedot .

FROM docker.io/library/ruby:4.0.5-slim AS base
WORKDIR /app
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends libpq5 curl && \
    rm -rf /var/lib/apt/lists/*

# Native gem extensions (pg, sassc) need compilers and headers
FROM base AS build
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists/*
COPY Gemfile Gemfile.lock ./

FROM build AS development
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

FROM build AS production-gems
ENV BUNDLE_WITHOUT="development:test" BUNDLE_FROZEN="true"
RUN bundle install

FROM base AS production
ENV RAILS_ENV="production" BUNDLE_WITHOUT="development:test" BUNDLE_FROZEN="true"
COPY --from=production-gems /usr/local/bundle /usr/local/bundle
COPY . .
# Boot (initializers) requires the app env vars; the example values only
# exist to let assets:precompile run and are not baked into the assets.
RUN set -a && . ./.env.example && set +a && bin/rails assets:precompile
RUN mkdir -p log tmp && useradd --create-home rails && chown -R rails: log tmp
USER rails
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
