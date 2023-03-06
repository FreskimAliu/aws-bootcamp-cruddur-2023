FROM node:16.19.1-alpine AS builder

RUN mkdir -p /frontend-react-js/node_modules && chown -R node:node /frontend-react-js

WORKDIR /frontend-react-js

# Set necessary environment variables needed for our image
ENV PORT=3000

# Change user to node
USER node

# Copy package.json and package-lock.json to container
COPY --chown=node:node package*.json ./
RUN npm install

FROM node:16.19.1-alpine

# Change user to node
USER node

WORKDIR /frontend-react-js

COPY --from=builder --chown=node:node /frontend-react-js/node_modules ./node_modules
COPY --chown=node:node . .

EXPOSE ${PORT}
CMD ["npm", "start"]