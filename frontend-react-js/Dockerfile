FROM node:16.19.1-alpine AS builder

RUN mkdir -p /app && chown -R node:node /app

WORKDIR /app

# Set necessary environment variables needed for our image
ENV PORT=3000

# Change user to node
USER node

# Copy package.json and package-lock.json to container
COPY --chown=node:node package*.json ./
RUN npm install

FROM node:16.19.1-alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --chown=node:node . .

EXPOSE ${PORT}
CMD ["npm", "start"]