# Stage 1: build the app
FROM node:20-alpine as builder

WORKDIR /app

# Copy dependencies
COPY package.json yarn.lock ./
RUN yarn install

# Copy source files
COPY . .

RUN yarn prisma generate

RUN yarn build

# Stage 2: run the app
FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./
COPY --from=builder /app/prisma ./prisma 

ENV NODE_ENV=production

CMD ["node", "dist/main"]
