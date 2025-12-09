FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (including dev dependencies for sequelize-cli)
RUN npm ci

# Copy application source code
COPY . .

# Set environment to production
ENV NODE_ENV=production

# Run migrations
CMD ["node", "migrate.js"]

