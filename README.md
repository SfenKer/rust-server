# Rust Server
A image for Docker that will automatically install Rust Server with Oxide.

# Example Usage

## Docker (CLI)
```shell
# Create Volume
docker volume create rust-server_data

# Start Container
docker run -d -t --name rust-server            \
    -p 28015:28015/udp -p 28016:28016/udp      \
    -p 28017:28017/tcp -p 28083:28083/tcp      \
    -v rust-server_data:/home/container/server \
    -e RCON_PASSWORD=MyStr0ngRc0nP4ssw0rd      \
    --restart=unless-stopped                   \
    ghcr.io/sfenker/rust-server:latest
```

## Docker (Compose)
```yaml
version: "3.9"
volumes:
  rust-server_data:

services:
  rust-server:
    container_name: rust-server
    image: ghcr.io/sfenker/rust-server:latest
    ports:
      - "28015:28015/udp"
      - "28016:28016/udp"
      - "28017:28017/tcp"
      - "28083:28083/tcp"
    environment:
      RCON_PASSWORD: "MyStr0ngRc0nP4ssw0rd"
    volumes:
      - rust-server_data:/home/container/server
    tty: true
    stdin_open: true
    restart: unless-stopped
```

# Environment Variables

| Variable               | Example Value                                                   | Description                                                                                                       |
|:----------------------:|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| `SERVER_ARGUMENTS`     | `-batchmode -load -nographics`                                  | Additional server arguments that can't be set by environment variables e.g. `+server.tags "EU,biweekly,vanilla"`. |
| `SERVER_IDENTITY`      | `default`                                                       | Identity of server instance, data files will be stored at `/server/<SERVER_IDENTITY>/`.                           |
| `SERVER_PORT`          | `28015`                                                         | Server Game Port *(UDP)*                                                                                          |
| `SERVER_QUERYPORT`     | `28016`                                                         | Server Query Port *(UDP)*                                                                                         |
| `SERVER_SEED`          | `2137`                                                          | World Seed *(variable `SERVER_LEVELURL` must not be set)*                                                         |
| `SERVER_LEVELURL`      | `https://rust-server.s3.amazonaws.com/maps/example.map`         | Map file download url, e.g. custom map, arenas or other like that.                                                |
| `SERVER_NAME`          | `Rust Server`                                                   | Display name of Rust server in listing.                                                                           |
| `SERVER_DESCRIPTION`   | `An amazing Rust server.`                                       | Description of Rust server.                                                                                       |
| `SERVER_URL`           | `https://rust.facepunch.com/`                                   | Link to server website.                                                                                           |
| `SERVER_BANNER_URL`    | `https://rust-server.s3.amazonaws.com/images/server_banner.png` | Server Banner URL                                                                                                 |
| `SERVER_WORLDSIZE`     | `4500`                                                          | Determines how large map will be.                                                                                 |
| `SERVER_MAXPLAYERS`    | `200`                                                           | How many players can be on server.                                                                                |
| `SERVER_SAVE_INTERVAL` | `600`                                                           | Interval of automatic world save.                                                                                 |
| `RCON_WEB`             | `1`                                                             | Is RCON websockets is enabled.                                                                                    |
| `RCON_PORT`            | `28017`                                                         | Port for RCON connections. *(TCP)*                                                                                |
| `RCON_PASSWORD`        | `password`                                                      | Password which will be used to authenticate RCON connections.                                                     |
| `APP_PORT`             | `28083`                                                         | Rust+ App Port (TCP)                                                                                              |
