# Chat
Simple webchat. Written in Elm and Haskell. Uses websockets.

## Installing
In `/frontend`:
```bash
npm install chokidar-cli --save-dev
elm-package install
```

In `/backend`:
```bash
cabal install websockets
cd ../out/backend
ghc -o server ../../backend/server.hs -odir . -hidir .
```

## Developing
Start a file watch server:
```bash
npm run watch
```

Copy static files to the output directory:
```bash
cp assets/* out/frontend
```

Run elm-reactor to be able to use it as a server:
```bash
elm-reactor
```

Run backend (`127.0.0.1:9160`):
```bash
./server
```

## Deployment
Configure Nginx (or whatever) to serve frontend statically.

Run `./server` in background process.

## Running docker
```bash
docker build --rm -f Dockerfile -t lambda-chat:latest .
docker run lambda-chat -p 80:80
```

## Explanation

#### What is `elm-package.json` for?
Dependencies of Elm project.

#### What is `package.json` for?
Chokidar is used to watch files and retranspile Elm every time some of its file changes.
