FROM tobix/pywine:3.12

# install nuitka in wine with all dlls and stuff
RUN curl https://www.dependencywalker.com/depends22_x86.zip -o /tmp/depends22_x86.zip
RUN mkdir -p /opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache/downloads/depends/x86_64/
RUN unzip /tmp/depends22_x86.zip -d /opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache/downloads/depends/x86_64/
# 1. Enable contrib and non-free repositories
RUN if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
        sed -i 's/Components: main/Components: main contrib non-free/g' /etc/apt/sources.list.d/debian.sources; \
    else \
        sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list; \
    fi

# 2. Update and install winetricks + dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends winetricks cabextract unzip xvfb && \
    rm -rf /var/lib/apt/lists/*
RUN xvfb-run winetricks -q mfc42

ENV NUITKA_CACHE_DIR=/opt/nuitka_cache
RUN mkdir -p /opt/nuitka_cache && chmod 777 /opt/nuitka_cache


COPY ./* /tmp/repo/
RUN /tmp/repo/warmup_uitka_cache.sh
