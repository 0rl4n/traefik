# Traefik Docker Setup

This repository contains a Docker Compose configuration for running [Traefik Proxy](https://traefik.io/traefik/), a modern reverse proxy and load balancer.

This setup is designed to act as the central gateway for all other services, providing automatic SSL, routing, and a secure dashboard.

## Features

-   **Automatic Service Discovery**: Dynamically configures itself by watching the Docker socket.
-   **Automatic SSL**: Integrates with Let's Encrypt to provide HTTPS for all services.
-   **Secure Dashboard**: Comes with a pre-configured, password-protected dashboard.
-   **Fully Parameterized**: All user-specific settings (domains, email) are managed via an `.env` file.

## Prerequisites

-   Docker & Docker Compose.
-   A domain name with DNS A-records pointing to your server's IP address.
-   Ports `80` and `443` must be open and available on the host machine.

## Installation

1.  **Clone the Repository**
    ```bash
    git clone <your-repo-url>
    cd traefik
    ```

2.  **Create the Proxy Network**
    This external network will be shared by all services that Traefik manages.
    ```bash
    docker network create proxy
    ```

3.  **Configure the Environment**
    Create your environment file from the example and fill in your domain and email.
    ```bash
    cp .env.example .env
    nano .env
    ```

4.  **Create Dashboard Credentials**
    Run the script to generate a `httpauth` file with a username and password for the Traefik dashboard.
    ```bash
    ./create-auth.sh
    ```

5.  **Initialize Certificate Storage**
    Create the file that will store your Let's Encrypt certificates and set the correct permissions.
    ```bash
    touch acme.json
    chmod 600 acme.json
    ```

6.  **Start the Service**
    ```bash
    docker compose up -d
    ```

## Configuration

All user-specific configuration is managed in the `.env` file.

| Variable | Description | Example |
|---|---|---|
| `TRAEFIK_DOMAIN` | The domain/subdomain for the Traefik dashboard. | `traefik.your-domain.com` |
| `LETSENCRYPT_EMAIL` | The email address for Let's Encrypt registration. | `your-email@example.com` |
| `PROJECT_PATH` | **Required.** Absolute path to this project directory. | `/root/services/traefik` |

## Maintenance

### Updating
```bash
docker compose pull
docker compose up -d
```

### Backup
The following files are critical and contain sensitive data. They should be backed up securely:
-   `./acme.json` (Your SSL certificates)
-   `./httpauth` (Your dashboard credentials)

### Troubleshooting
To view the logs for the service:
```bash
docker compose logs -f
```
