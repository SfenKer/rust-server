FROM debian:bookworm-slim

# Arguments
ARG DEBIAN_FRONTEND=noninteractive

# Copy Requirements
RUN rm /etc/apt/sources.list.d/debian.sources
COPY cfg/sources.list /etc/apt/sources.list

# Steam Prompt Answers
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections

# Install SteamCMD
RUN dpkg --add-architecture i386                                                                  && \
    apt-get update -y                                                                             && \
    apt-get install -y --no-install-recommends acl curl jq unzip ca-certificates locales steamcmd && \
    rm -rf /var/lib/apt/lists/*

# System Configuration
RUN useradd -r -d /home/container -s /bin/bash admin && \
    mkdir -p /home/container                         && \
    chown admin:admin /home/container

ENV HOME=/home/container
WORKDIR /home/container

ENV LANG='en_US.UTF-8'
ENV LANGUAGE='en_US:en'
RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen en_US.UTF-8

# Install Websocat
RUN curl -sL $(curl -s https://api.github.com/repos/vi/websocat/releases | jq -r '[.[] | select(.prerelease==true or .prerelease==false)][0].assets[] | select(.name | test("websocat.*x86_64.*linux")) | .browser_download_url') -o /bin/websocat && \
    chmod +x /bin/websocat

# Create SymLinks
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Post Install
USER admin
RUN mkdir -p ~/.steam                  && \
    mkdir -p ~/server                  && \
    mkdir -p ~/storage                 && \
    mkdir -p ~/scripts/shell           && \
    mkdir -p ~/scripts/steamcmd        && \
    mkdir -p ~/scripts/shell/installer

RUN steamcmd +quit                                    && \
    rm -rf ~/.local/share/Steam/steamcmd/package      && \
    rm -rf ~/.local/share/Steam/steamcmd/public       && \
    rm -rf ~/.local/share/Steam/steamcmd/siteserverui && \
    rm -rf ~/.local/share/Steam/steamcmd/steamcmd.sh  && \
    rm -rf ~/Steam/
    
RUN ln -s ~/.local/share/Steam/steamcmd/linux32 ~/.steam/sdk32         && \
    ln -s ~/.local/share/Steam/steamcmd/linux64 ~/.steam/sdk64         && \
    ln -s ~/.steam/sdk32/steamclient.so ~/.steam/sdk32/steamservice.so && \
    ln -s ~/.steam/sdk64/steamclient.so ~/.steam/sdk64/steamservice.so

COPY --chown=admin:admin scripts/shell/run_server.sh /home/container/scripts/shell/run_server.sh
COPY --chown=admin:admin scripts/shell/entrypoint.sh /home/container/scripts/shell/entrypoint.sh
COPY --chown=admin:admin scripts/shell/installer/rust_installer.sh /home/container/scripts/shell/installer/rust_installer.sh
COPY --chown=admin:admin scripts/shell/installer/oxide_installer.sh /home/container/scripts/shell/installer/oxide_installer.sh
COPY --chown=admin:admin scripts/steamcmd/install_dedicated_server.txt /home/container/scripts/steamcmd/install_dedicated_server.txt

RUN chmod +x ~/scripts/shell/run_server.sh                && \
    chmod +x ~/scripts/shell/entrypoint.sh                && \
    chmod +x ~/scripts/shell/installer/rust_installer.sh  && \
    chmod +x ~/scripts/shell/installer/oxide_installer.sh

VOLUME /home/container/server/

USER root
RUN ln -s /home/container/scripts/shell/entrypoint.sh /entrypoint.sh

# Default Environment Variables
ENV SERVER_ARGUMENTS "-batchmode -load -nographics"
ENV SERVER_IDENTITY "default"
ENV SERVER_PORT "28015"
ENV SERVER_QUERYPORT "28016"
ENV SERVER_SEED "2137"
ENV SERVER_LEVELURL=""
ENV SERVER_NAME "Rust Server"
ENV SERVER_DESCRIPTION "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
ENV SERVER_URL "https://rust.facepunch.com/"
ENV SERVER_BANNER_URL "https://files.facepunch.com/Alistair/107/08/2025/2X00/rust_hardercore-hero-image-v2-1080.jpg"
ENV SERVER_WORLDSIZE "4500"
ENV SERVER_MAXPLAYERS "200"
ENV SERVER_SAVE_INTERVAL "600"

ENV RCON_WEB "1"
ENV RCON_PORT "28017"
ENV RCON_PASSWORD "password"

ENV APP_PORT "28083"

# Expose Ports
EXPOSE 28015
EXPOSE 28016
EXPOSE 28017
EXPOSE 28083

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]