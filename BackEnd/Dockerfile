# 빌드 단계
FROM node:18 AS builder
WORKDIR /app
COPY BackEnd/package*.json ./
RUN npm install
COPY BackEnd/ .
COPY BackEnd/public /app/public
RUN npm run build

# 실행 단계
FROM node:18
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./
RUN npm install --only=production
RUN npm install pm2 -g
EXPOSE 3000
CMD ["pm2-runtime", "start", "dist/main.js"]

