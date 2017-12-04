FROM haskell:latest
ADD . app
EXPOSE 9160

# Install and compile for backend.
RUN apt-get update \
    && cd app/backend \
    && cabal update \
    # Install backend dependency.
    && cabal install websockets \
    && cd .. \
    # Compile server.
    && ghc -o server backend/server.hs -odir out/backend -hidir out/backend \
    && cd frontend

# Install elm.
RUN apt-get install -y nodejs \
    && apt-get install npm \
    && npm install -g elm \
    # Transpile elm to js output.
    && elm-make src/Main.elm --output ../out/frontend/main.js \
    && cd .. \
    # Copy static assets.
    && cp frontend/assets/* out/frontend

# Install nginx.
RUN apt-get install -y nginx \
    && mv lambda-chat.conf /etc/nginx/sites-available \
    && ln -s /etc/nginx/sites-available/lambda-chat.conf /etc/nginx/sites-enabled/lambda-chat.conf \
    && systemctl restart nginx

CMD ["app/out/backend/server", "&"]
