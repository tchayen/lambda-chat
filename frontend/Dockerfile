FROM node:7.2.0 as build
WORKDIR app
ADD . .
RUN npm install -g elm@0.18.0
RUN npm install -g elm-test@0.18.0
RUN mkdir build \
    && elm-make --yes src/Main.elm --output build/main.js \
    && cp assets/* build

FROM nginx:latest
WORKDIR app
ADD ./config .
COPY --from=build /app/build frontend
EXPOSE 80
RUN mv lambda-chat.conf /etc/nginx/conf.d/default.conf
