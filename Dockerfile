# Use a lightweight image with bash and cron
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y curl cron && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY word_of_the_day.zsh .
COPY entrypoint.sh .

# Make them executable
RUN chmod +x word_of_the_day.zsh entrypoint.sh

# Strip off windows carriage-returns
RUN sed -i 's/\r//' /app/entrypoint.sh /app/word_of_the_day.zsh

# Add cron job
RUN echo "00 18 * * * root /bin/bash /app/word_of_the_day.zsh >> /var/log/word_of_the_day.log 2>&1" > /etc/cron.d/word_of_the_day \
    && chmod 0644 /etc/cron.d/word_of_the_day \
    && crontab /etc/cron.d/word_of_the_day

# Create log file so cron can write to it
RUN touch /var/log/word_of_the_day.log

CMD ["/app/entrypoint.sh"]
