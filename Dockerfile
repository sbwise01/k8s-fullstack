FROM node:18-alpine AS base

# Install deps
FROM base as deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY app/next-fe/package.json app/next-fe/pnpm-lock.yaml* ./
RUN yarn global add pnpm
RUN pnpm install

# BUILDER
FROM base as builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app/next-fe .
RUN npm run build

FROM base as runner
WORKDIR /app
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
# set hostname to localhost
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
