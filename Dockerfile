FROM oven/bun:1 AS prepare

WORKDIR /app

COPY . .
RUN bun i --frozen-lockfile --production --ignore-scripts

FROM oven/bun:1 AS builder

WORKDIR /app

COPY packages ./packages
COPY src ./src
COPY package.json .
COPY --from=prepare /app/node_modules ./node_modules
RUN bun run build

FROM oven/bun:1 AS runner

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY package.json bunfig.toml ./

CMD ["bun", "run", "start"]
