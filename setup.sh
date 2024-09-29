#!/bin/bash

# PostgreSQL configuration variables
POSTGRES_PASSWORD="postgres"
DATABASE_NAME="public"
CONTAINER_NAME="postgres_conteiner"

# Function to check the success of a command
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if the container already exists and remove it if necessary
if [ "$(docker ps -aq -f name=postgres_conteiner)" ]; then
    echo "Removing existing container..."
    docker rm -f postgres_conteiner
fi

# Create a Dockerfile
echo "Creating Dockerfile..."
cat <<EOF > Dockerfile
FROM postgres:latest

# Install sudo, python3, python3-venv, git, and expect
RUN apt-get update && apt-get install -y sudo python3 python3-venv git expect

# Create the alpaca directory
RUN mkdir /fast_dbt

# Expose the default PostgreSQL port
EXPOSE 5432
EOF

# Build the Docker image
echo "Building Docker image..."
docker build -t my_postgres_image . 
check_success "Failed to build Docker image."

# Create and start the container with volume for the CSV and more resources
echo "Starting Docker container..."
docker run --name postgres_conteiner \
    -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
    -p 5432:5432 \
    -d my_postgres_image
check_success "Failed to create and start the container."

# Wait for PostgreSQL to start
echo "Waiting for PostgreSQL to start..."
sleep 30

# Create the database and schema
echo "Creating database and schema..."
docker exec -it postgres_conteiner psql -U postgres -c "CREATE DATABASE $DATABASE_NAME;"
check_success "Failed to create database and schema."

# Configure and install dbt
echo "Configuring dbt..."
docker exec -it postgres_conteiner bash -c "
    cd /fast_dbt && \
    python3 -m venv myenv && \
    source myenv/bin/activate && \
    pip install dbt-core dbt-postgres --no-input && \
    mkdir -p /root/.dbt && \
    echo 'fast_dbt:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: postgres
      pass: postgres
      dbname: public
      schema: public
      threads: 1' > /root/.dbt/profiles.yml && \
    dbt init dbt_fastdbt --profiles-dir /root/.dbt && \
    mkdir -p /fast_dbt/dbt_fastdbt/models/staging /fast_dbt/dbt_fastdbt/models/intermediate/fast_dbt/dbt_fastdbt/models/marts
"
check_success "Failed to configure dbt and create additional folders."

# Run dbt again
echo "Running dbt again..."
docker exec -it postgres_conteiner bash -c "
    cd /fast_dbt/dbt_fastdbt && \
    source /fast_dbt/myenv/bin/activate && \
    dbt build --full-refresh
"
check_success "Failed to run dbt again."