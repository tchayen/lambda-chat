FROM haskell:7.10
ADD . app
ENV PATH /opt/Elm-Platform/$0.18/.cabal-sandbox/bin:$PATH

# Install and compile for backend.
RUN apt-get update && apt-get install -y curl libtinfo-dev git \
    && cd app/backend \
    # Install backend dependency.
    && cabal update && cabal install websockets \
    # Compile server.
    && ghc -o server server.hs -odir ../out/backend -hidir ../out/backend \
    # Install Node.
    && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get install -y nodejs \
    # Install Elm.
    && curl https://raw.githubusercontent.com/elm-lang/elm-platform/ba667c435f03c8f938b03cd8997b1801857d202b/installers/BuildFromSource.hs > BuildFromSource.hs \
    && runhaskell BuildFromSource.hs 0.18 \
    # Compile elm to js output.
    && cd /app/frontend \
    && elm-make src/Main.elm --output ../out/frontend/main.js \
    # Copy static assets.
    && cp assets/* ../out/frontend \
    # Install nginx.
    && apt-get install -y nginx \
    && mv lambda-chat.conf /etc/nginx/sites-available \
    && ln -s /etc/nginx/sites-available/lambda-chat.conf /etc/nginx/sites-enabled/lambda-chat.conf \

EXPOSE 9160
CMD ["app/out/backend/server", "&"]
