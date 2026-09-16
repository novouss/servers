FROM debian:trixie-slim AS base

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

COPY bootstrap.sh /terraria-server/bootstrap.sh

ENV DL_VERSION=1456
ENV DL_LINK=https://terraria.org/api/download/pc-dedicated-server/terraria-server-$DL_VERSION.zip
ENV DL_FILE=terraria-server-$DL_VERSION.zip

ADD $DL_LINK /$DL_FILE

RUN unzip /$DL_FILE -d /terraria && \
    mv /terraria/$DL_VERSION/Linux/* /terraria-server && \
    mv /terraria/$DL_VERSION/Windows/serverconfig.txt /terraria-server/serverconfig-default.txt && \
    chmod +x /terraria-server/TerrariaServer*

FROM debian:trixie-slim

EXPOSE 7777

ENV LOGPATH=/terraria-server/logs
ENV WORLDPATH=/root/.local/share/Terraria/Worlds
ENV WORLD_FILENAME=""
ENV CONFIGPATH=/config
ENV CONFIG_FILENAME="serverconfig.txt"
ENV TARGETARCH=${TARGETARCH}

COPY --from=base /terraria-server/ /terraria-server/

RUN if [ "${TARGETARCH}" = "arm64" ] || [ "${TARGETARCH}" = "arm" ]; then \
        apt-get update && apt-get install -y ca-certificates mono-runtime && rm -rf /var/lib/apt/lists/*; \
        # The provided system.dll form terraria doesn't match the mono version.
        mv /terraria-server/System.dll /usr/lib/mono/4.5/System.dll; \
    fi

VOLUME [ "${WORLDPATH}", "${CONFIGPATH}", "${LOGPATH}" ]

WORKDIR /terraria-server

ENTRYPOINT [ "/bin/sh", "bootstrap.sh" ]

