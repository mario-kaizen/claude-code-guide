FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY img/ /usr/share/nginx/html/img/
COPY command-centre/ /usr/share/nginx/html/command-centre/
EXPOSE 80
