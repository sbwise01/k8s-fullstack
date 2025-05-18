###################
# Base images
###################
FROM node:18-alpine AS frontend-base
FROM alpine:3 as api-base

###################
# Frontend deps
###################
FROM frontend-base as frontend-deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY app/next-fe/package.json app/next-fe/pnpm-lock.yaml* ./
RUN yarn global add pnpm
RUN pnpm install

###################
# Frontend builder
###################
FROM frontend-base as frontend-builder
WORKDIR /app
COPY --from=frontend-deps /app/node_modules ./node_modules
COPY app/next-fe .
RUN npm run build

###################
# Frontend runner
###################
FROM frontend-base as frontend-runner
WORKDIR /app
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=frontend-builder /app/public ./public

COPY --from=frontend-builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=frontend-builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
# set hostname to localhost
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]

###################
# API runner
###################
FROM api-base as api-runner
LABEL maintainer="brad@foghornconsulting.com"

COPY app/python-api/requirements.txt /tmp/requirements.txt
RUN apk add --no-cache py3-pip curl \
    && pip install --upgrade pip --break-system-packages \
    && pip install -r /tmp/requirements.txt --break-system-packages

ENV FLASK_APP app.py
RUN mkdir /app
COPY app/python-api/app.py /app

VOLUME /app
EXPOSE 5000

# Cleanup
RUN rm -rf /.wh /root/.cache /var/cache /tmp/requirements.txt

WORKDIR /app
CMD ["/usr/bin/flask", "run", "--reload", "-h", "0.0.0.0"]
