FROM node:12-alpine AS production

# Add Tini to ensure that the application will be responding to SIGINT
RUN apk add --no-cache tini

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

ENV NODE_ENV production

COPY package.json ./

USER node

RUN npm install

COPY --chown=node:node . .

EXPOSE 3000

ENTRYPOINT ["/sbin/tini", "--"]

CMD [ "node", "./bin/www" ]

