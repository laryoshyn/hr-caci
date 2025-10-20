# Use Nginx base image (Debian-based for Dokploy compatibility)
FROM nginx:latest

# Copy the presentation HTML file to the Nginx web root
COPY presentation-caci.html /usr/share/nginx/html/index.html

# Expose port 80, the default HTTP port Nginx listens on
EXPOSE 80

# Command to run Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
