# Use a lightweight Linux image
FROM alpine:latest

# Install zsh (and curl if your script fetches data from the internet)
RUN apk add --no-cache zsh curl

# Set working directory
WORKDIR /app

# Copy your script into the container
COPY word_of_the_day.zsh .

# Make it executable
RUN chmod +x word_of_the_day.zsh

# Run the script
CMD ["zsh", "word_of_the_day.zsh"]
