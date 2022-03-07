# Stage 1: install dependencies
FROM node:17-alpine AS deps
WORKDIR /app
COPY package*.json .
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
RUN npm install

# Stage 2: build
FROM node:17-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY src ./src
COPY public ./public
COPY package.json next.config.js jsconfig.json ./
RUN npm run build && \
  mkdir /outputs && \
  cp -r .next public node_modules package.json /outputs

# Stage 3: run
FROM node:17-alpine
WORKDIR /app
COPY --from=builder /outputs ./
CMD ["npm", "run", "start"]
