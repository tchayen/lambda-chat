FROM haskell:latest as build
WORKDIR app
ADD . .
RUN mkdir build \
  && cabal update && cabal install websockets \
  && ghc -o build/server server.hs -odir . -hidir .

FROM ubuntu:latest
WORKDIR app
COPY --from=build /app/build backend
EXPOSE 9160
# Install stack (to be able to run server's exec).
RUN apt-get update \
  && apt-get install -y curl \
  && curl -sSL https://get.haskellstack.org/ | sh
CMD ["backend/server"]
