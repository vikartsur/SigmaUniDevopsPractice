FROM nginx:latest
ARG CURRENT_ENVIRONMENT

ENV CURRENT_ENVIRONMENT = ${CURRENT_ENVIRONMENT}

RUN mkdir -p /usr/share/nginx/html

RUN echo "<!DOCTYPE html>" > /usr/share/nginx/html/index.html && \
    echo "<html>" >> /usr/share/nginx/html/index.html && \
    echo "<head><meta charset="UTF-8"><title>Docker training. DK</title></head>" >> /usr/share/nginx/html/index.html && \
    echo "<body>" >> /usr/share/nginx/html/index.html && \
    echo "<p>Current Environment: ${CURRENT_ENVIRONMENT}</p>" >> /usr/share/nginx/html/index.html && \
    echo "<p>Я люблю пельмені зі сметаною!</p>" >> /usr/share/nginx/html/index.html && \
    echo "</body>" >> /usr/share/nginx/html/index.html && \
    echo "</html>" >> /usr/share/nginx/html/index.html

EXPOSE 50

CMD ["nginx", "-g", "daemon off;"]
