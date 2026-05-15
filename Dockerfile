# Build Flutter web app — run from `novora_flutter/`:
#   docker build -t novora-web .
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY pubspec.yaml ./
RUN flutter pub get
COPY . .
# pubspec bundles `.env` as an asset; host `.env` is dockerignored — use committed defaults.
RUN cp .env.docker .env
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
