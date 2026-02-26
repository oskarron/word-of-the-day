# Use a lightweight image with bash and cron
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y curl cron && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy your script
COPY word_of_the_day.zsh .

# Make it executable
RUN chmod +x word_of_the_day.zsh

# Add a cron job file
# This will run the script every day at 12:00
RUN echo "28 18 * * * /app/word_of_the_day.zsh >> /var/log/word_of_the_day.log 2>&1" > /etc/cron.d/word_of_the_day
# Give cron permission to run
RUN chmod 0644 /etc/cron.d/word_of_the_day

# Apply cron job
RUN crontab /etc/cron.d/word_of_the_day

# Create log file so cron can write to it
RUN touch /var/log/word_of_the_day.log

# Start cron in foreground so container keeps running
CMD ["cron", "-f"]
