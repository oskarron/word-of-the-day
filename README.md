# word-of-the-day

## How to run

``` bash
docker build -t wotd .
docker run -e DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/[...] wotd
```

## Utilities

### Wipe all local containers and images

``` bash
docker rm -f $(docker ps -aq);docker rmi -f $(docker images -aq);
```