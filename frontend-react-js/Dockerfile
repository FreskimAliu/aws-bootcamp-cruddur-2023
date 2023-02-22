FROM node:16.18-alpine

RUN mkdir -p /home/node/frontend-react-js && chown -R node:node /home/node/frontend-react-js

WORKDIR /home/node/frontend-react-js

# Set necessary environment variables needed for our image
ENV PORT=3000

# Change user to node
USER node

# Copy package.json and package-lock.json to container
COPY --chown=node:node package*.json ./
RUN npm install

COPY --chown=node:node . .

EXPOSE ${PORT}
CMD ["npm", "start"]