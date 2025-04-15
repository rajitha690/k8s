# Use the official Node.js LTS image
FROM node:18-alpine

# Set the working directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy application source code
COPY . .

# Expose the application's port
EXPOSE 3000

# Define the command to run the application
CMD ["npm", "start"]
