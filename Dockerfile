# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Install prerequisites
RUN apt-get update && \
    apt-get install -y gnupg wget ca-certificates && \
    apt-get clean

# Import the MongoDB public GPG key
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -

# Add MongoDB repository to sources list
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list

# Update package lists again
RUN apt-get update

# Install MongoDB packages
RUN apt-get install -y mongodb-org

# Clean up installation files
RUN rm -rf /var/lib/apt/lists/*

# Create the MongoDB data directory
RUN mkdir -p /data/db

# Copy MongoDB configuration file with authentication enabled
COPY mongod.conf /etc/mongod.conf

# Copy initialization script
COPY init-mongo.sh /usr/local/bin/init-mongo.sh
RUN chmod +x /usr/local/bin/init-mongo.sh

# Expose port 27017 from the container to the host
EXPOSE 27017

# Start MongoDB service
CMD ["init-mongo.sh"]