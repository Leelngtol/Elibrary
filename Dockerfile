# Stage 1: build the React website
FROM node:24-alpine AS web
WORKDIR /web
COPY web/package.json web/package-lock.json ./
RUN npm ci
COPY web/ ./
RUN npm run build

# Stage 2: production API server that also serves the website
FROM node:24-alpine
ENV NODE_ENV=production PORT=3000
WORKDIR /app
COPY backend/package.json backend/package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY backend/src ./src
COPY backend/data/books.json ./data/books.json
COPY backend/downloads ./downloads
COPY --from=web /web/dist ./public
RUN addgroup -S app && adduser -S app -G app && mkdir -p /app/data/pgdata && chown -R app:app /app/data
USER app
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s CMD wget -qO- http://127.0.0.1:3000/api/health || exit 1
CMD ["node", "src/server.js"]
