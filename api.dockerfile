FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application source code
COPY . .

EXPOSE 4567

# Set environment to production
ENV NODE_ENV=production

# Start the application
CMD ["node", "index.js"]

