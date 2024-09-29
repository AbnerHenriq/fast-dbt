# fast-dbt

Welcome to the **Fast DBT Project**! This project streamlines the setup of a PostgreSQL database along with a [dbt](https://www.getdbt.com/) (Data Build Tool) project using Docker. The provided `setup.sh` script automates the entire process, allowing you to get started with data transformation and modeling quickly and efficiently.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Usage](#usage)


## Overview

This project automates the following tasks:

- Builds a custom PostgreSQL Docker image with necessary dependencies.
- Runs a PostgreSQL container from the custom image.
- Installs and configures dbt inside the container.
- Initializes a new dbt project.
- Sets up the directory structure for dbt models.

By running a single script, you set up a ready-to-use environment for data transformation and analysis.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Docker**: Install Docker on your machine. [Download Docker](https://www.docker.com/get-started)
- **Bash Shell**: Ensure you are running a Unix-like environment with Bash installed.
- **Git** (optional): For cloning the repository if you choose to use Git.

## Getting Started

Follow these steps to get the project up and running:

### 1. Clone the Repository

Clone this repository to your local machine using Git:

```bash
git clone https://github.com/yourusername/fast-dbt.git
cd fast-dbt
```

Alternatively, you can download the repository as a ZIP file and extract it.

### 2. Make the Setup Script Executable

Grant execute permissions to the `setup.sh` script:

```bash
chmod +x setup.sh
```

### 3. Run the Setup Script

Execute the script to build the Docker image and start the container:

```bash
./setup.sh
```

**Note**: The script may take several minutes to complete as it builds the Docker image and sets up the environment.

## Project Structure

- **setup.sh**: The main script that automates the setup process.
- **Dockerfile**: Defines the custom Docker image with PostgreSQL and additional dependencies.
- **/fast_dbt**: Directory inside the Docker container where the dbt project and virtual environment are located.

## Usage

After the setup script completes, you can start using the dbt project inside the Docker container.

### Accessing the Docker Container

Enter the running container's shell:

```bash
docker exec -it postgres_container bash
```

### Activating the Python Virtual Environment

Inside the container, activate the virtual environment:

```bash
source /fast_dbt/myenv/bin/activate
```

### Navigating to the dbt Project

Change to the dbt project directory:

```bash
cd /fast_dbt/dbt_fastdbt
```

