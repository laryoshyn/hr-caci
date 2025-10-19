# Use a lightweight Nginx base image
FROM nginx:alpine

# Copy the presentation HTML file to the Nginx web root
COPY presentation-caci.html /usr/share/nginx/html/index.html

# Expose port 80, the default HTTP port Nginx listens on
EXPOSE 80

# Command to run Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
