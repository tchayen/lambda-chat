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
stack install
stack build
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

Run elm-reactor in `out` to be able to use it as a server:
```bash
elm-reactor
```
And now you can visit `http://localhost:8000/frontend/main.html`

Run backend:
```bash
# assuming you have ~/.local/bin in your $PATH:
lambda-chat-backend-exe
```

## Deployment
Configure Nginx (or whatever) to serve frontend statically.

Run server in background process.

## Explanation

#### What is `elm-package.json` for?
Dependencies of Elm project.

#### What is `package.json` for?
Chokidar is used to watch files and retranspile Elm every time some of its file changes.
