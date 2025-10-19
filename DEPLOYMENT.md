# Deployment Guide

This guide provides instructions for deploying the CACI AI Workforce Transformation presentation.

## Project Structure

```
hr-caci/
├── presentation-caci.html   # Interactive presentation with D3.js visualizations
├── Dockerfile               # Docker container configuration
├── docker-compose.yml       # Docker Compose for easy deployment
├── .dockerignore           # Files excluded from Docker build
└── DEPLOYMENT.md           # This file
```

## Local Deployment

### Using Docker

```bash
# Build the image
docker build -t caci-presentation .

# Run the container
docker run -d -p 8080:80 --name caci-presentation caci-presentation

# Access at http://localhost:8080
```

### Using Docker Compose

```bash
# Start the service
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the service
docker-compose down

# Access at http://localhost:8080
```

## Dokploy Deployment

### Method 1: Deploy from GitHub Repository

1. **Login to your Dokploy dashboard**

2. **Create a new application**
   - Click "Create Application"
   - Choose "Docker" as the application type

3. **Configure Git Repository**
   - Repository URL: `https://github.com/laryoshyn/hr-caci`
   - Branch: `main`
   - Build Method: `Dockerfile`

4. **Configure Build Settings**
   - Dockerfile Path: `./Dockerfile`
   - Build Context: `.`
   - No build arguments needed

5. **Configure Runtime Settings**
   - Port: `80` (internal container port)
   - Expose Port: `8080` (or your preferred external port)
   - Health Check Path: `/` (optional)

6. **Deploy**
   - Click "Deploy"
   - Wait for build and deployment to complete
   - Access your application at the provided URL

### Method 2: Deploy using Docker Compose

1. **Create a new application in Dokploy**
   - Choose "Docker Compose" as the application type

2. **Configure Git Repository**
   - Repository URL: `https://github.com/laryoshyn/hr-caci`
   - Branch: `main`

3. **Set Compose File**
   - Compose File Path: `./docker-compose.yml`

4. **Deploy**
   - Click "Deploy"
   - Dokploy will use the docker-compose.yml configuration

### Method 3: Manual Docker Image Push

```bash
# Build and tag the image
docker build -t your-registry/caci-presentation:latest .

# Push to your container registry
docker push your-registry/caci-presentation:latest

# In Dokploy, create a new application using the image
# Image: your-registry/caci-presentation:latest
# Port: 80
```

## Environment Configuration

The application uses a simple Nginx server and requires no environment variables.

### Optional Environment Variables (for advanced configuration)

- `NGINX_HOST`: Default is `localhost`
- `NGINX_PORT`: Default is `80`

## Port Configuration

- **Container Port**: 80 (Nginx default)
- **Host Port**: 8080 (configurable in docker-compose.yml or Dokploy settings)

## Health Checks

The docker-compose.yml includes a health check that verifies Nginx is responding:

```yaml
healthcheck:
  test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:80"]
  interval: 30s
  timeout: 10s
  retries: 3
```

## Troubleshooting

### Container won't start

```bash
# Check container logs
docker logs caci-presentation

# Or with docker-compose
docker-compose logs caci-presentation
```

### Port already in use

```bash
# Change the port in docker-compose.yml
ports:
  - "3000:80"  # Use port 3000 instead of 8080

# Or when running manually
docker run -d -p 3000:80 --name caci-presentation caci-presentation
```

### Build fails

```bash
# Ensure all required files are present
ls -la presentation-caci.html Dockerfile

# Rebuild without cache
docker build --no-cache -t caci-presentation .
```

## Updating the Deployment

### Dokploy Auto-Deploy

Set up automatic deployments in Dokploy:
1. Go to your application settings
2. Enable "Auto Deploy" for the `main` branch
3. Any push to GitHub will trigger automatic redeployment

### Manual Update

```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up -d --build
```

## Performance Optimization

The presentation loads external resources from CDNs:
- **D3.js**: https://d3js.org/d3.v7.min.js
- **Google Fonts**: https://fonts.googleapis.com/css2

Ensure your deployment environment has internet access for these resources.

## Security Considerations

- The application serves static HTML content only
- No backend processing or database connections
- No sensitive data storage
- Consider adding HTTPS/SSL in production (Dokploy typically handles this)

## Support

- **GitHub Repository**: https://github.com/laryoshyn/hr-caci
- **Dokploy Documentation**: https://docs.dokploy.com

## Resource Requirements

**Minimum Requirements:**
- CPU: 0.1 cores
- RAM: 64MB
- Disk: 50MB

**Recommended for Production:**
- CPU: 0.25 cores
- RAM: 128MB
- Disk: 100MB

The application is extremely lightweight and will run on minimal resources.
