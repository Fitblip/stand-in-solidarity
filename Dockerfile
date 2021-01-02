FROM node:alpine

RUN apk add elixir python build-base

ENV MIX_HOME=/root/
RUN mix do local.hex --force, local.rebar --force

WORKDIR /app

COPY . .

RUN npm install

RUN npm run build

RUN cd ping && mix do deps.get, deps.compile, compile

CMD cd ping && mix run --no-halt
