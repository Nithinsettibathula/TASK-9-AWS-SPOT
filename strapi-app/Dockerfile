# Stage 1: Build the application
FROM node:18-alpine as build
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev > /dev/null 2>&1
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Mandatory Strapi Environment Variables for the build process
ENV APP_KEYS="testKey1,testKey2"
ENV API_TOKEN_SALT="testSalt"
ENV ADMIN_JWT_SECRET="testAdminSecret"
ENV JWT_SECRET="testJwtSecret"

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm install --production
ENV PATH /opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .
RUN npm run build

# Stage 2: Final Runtime Image
FROM node:18-alpine
RUN apk add --no-cache vips-dev
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Mandatory Strapi Environment Variables for the runtime
ENV APP_KEYS="testKey1,testKey2"
ENV API_TOKEN_SALT="testSalt"
ENV ADMIN_JWT_SECRET="testAdminSecret"
ENV JWT_SECRET="testJwtSecret"

WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
WORKDIR /opt/app
COPY --from=build /opt/app ./

ENV PATH /opt/node_modules/.bin:$PATH

RUN chown -R node:node /opt/app
USER node
EXPOSE 1337
CMD ["npm", "run", "start"]