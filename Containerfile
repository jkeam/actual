FROM registry.access.redhat.com/ubi9/nodejs-22:9.5-1736454190
USER 0
RUN mkdir -p /opt/app-root/src/.yarn/berry
RUN chown 1001:0 -R /opt/app-root

# install deps
ENV NODE_ENV=production
COPY ./.yarn ./.yarn
COPY ./yarn.lock ./packages/sync-server/package.json ./.yarnrc.yml ./

RUN npm install --global yarn
RUN yarn install

# app files
COPY ./packages/sync-server/app.js ./
COPY ./packages/sync-server/src ./src
COPY ./packages/sync-server/migrations ./migrations

# permissions
RUN chown -R 1001:0 .
USER 1001
EXPOSE 5006

# app
CMD ["node", "app.js"]
