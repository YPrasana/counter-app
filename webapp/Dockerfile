
# Base image]
FROM node:14-alpine

# Create app working directory
WORKDIR /app

# Create app working directory
COPY package*.json ./
RUN npm install

COPY src/* .

# Expose port 8080
EXPOSE 8080

# Start the server
ENTRYPOINT [ "node", "app.js" ]
