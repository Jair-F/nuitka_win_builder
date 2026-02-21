FROM tobix/pywine:3.12

# install nuitka in wine with all dlls and stuff
RUN curl https://www.dependencywalker.com/depends22_x64.zip -o /tmp/depends22_x64.zip
# Fix for 64-bit Dependency Walker
RUN mkdir -p /opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache/downloads/depends/x86_64/ && \
    unzip /tmp/depends22_x64.zip -d /opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache/downloads/depends/x86_64/

    # 1. Enable contrib and non-free repositories
RUN if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
        sed -i 's/Components: main/Components: main contrib non-free/g' /etc/apt/sources.list.d/debian.sources; \
    else \
        sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list; \
    fi

# 2. Update and install winetricks + dependencies
RUN apt update && \
    apt install -y --no-install-recommends winetricks cabextract unzip xvfb && \
    rm -rf /var/lib/apt/lists/*
RUN xvfb-run winetricks -q mfc42

# add linux GUI libs - opencv
RUN apt update && \
    apt install -y --no-install-recommends \
    winetricks cabextract unzip xvfb \
    libgl1 libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

# Microsoft Visual C++ Runtime
RUN curl https://download.visualstudio.microsoft.com/download/pr/9e04d214-5a9d-4515-9960-3d71398d98c3/1e1e62ab57bbb4bf5199e8ce88f040be/vc_redist.x64.exe -o /tmp/vc_redist.x64.exe
RUN xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" wine64 /tmp/vc_redist.x64.exe /quiet /install /norestart
RUN rm /tmp/vc_redist.x64.exe


COPY ./* /tmp/repo/
RUN wine python -m pip install -r /tmp/repo/requirements_nuitka.txt

RUN /tmp/repo/warmup_nuitka_cache.sh