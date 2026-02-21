FROM tobix/pywine:3.10

# 1. Force Wine to use the Native (Microsoft) Runtimes we install later
# This fixes the "unimplemented function ucrtbase.dll.crealf" crash
# ENV WINEDLLOVERRIDES="ucrtbase=n,builtin;vcruntime140=n,builtin;msvcp140=n,builtin"
# This environment variable tells Nuitka to download the compiler without asking
# ENV NUITKA_CACHE_DIR="/opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache"
# ENV NUITKA_PYTHON_FLAGS="-m"


# Fix for 64-bit Dependency Walker
# RUN curl https://www.dependencywalker.com/depends22_x64.zip -o /tmp/depends22_x64.zip && \
#     mkdir -p /opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache/downloads/depends/x86_64/ && \
#     unzip -j /tmp/depends22_x64.zip -d /opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache/downloads/depends/x86_64/ && \
#     rm /tmp/depends22_x64.zip
# Fix for 32-bit Dependency Walker in 64bit directory
RUN curl https://www.dependencywalker.com/depends22_x86.zip -o /tmp/depends22_x86.zip && \
    mkdir -p /opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache/downloads/depends/x86_64/ && \
    unzip -j /tmp/depends22_x86.zip -d /opt/wineprefix/drive_c/users/root/AppData/Local/Nuitka/Nuitka/Cache/downloads/depends/x86_64/ && \
    rm /tmp/depends22_x86.zip


# 3. System dependencies
RUN if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
        sed -i 's/Components: main/Components: main contrib non-free/g' /etc/apt/sources.list.d/debian.sources; \
    else \
        sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list; \
    fi && \
    apt update && \
    apt install -y --no-install-recommends winetricks cabextract unzip xvfb libgl1 libglib2.0-0 curl && \
    rm -rf /var/lib/apt/lists/*

# Windows Runtimes
RUN xvfb-run winetricks -q mfc42
# RUN curl -L https://download.visualstudio.microsoft.com/download/pr/9e04d214-5a9d-4515-9960-3d71398d98c3/1e1e62ab57bbb4bf5199e8ce88f040be/vc_redist.x64.exe -o /tmp/vc_redist.x64.exe && \
#     xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" wine64 /tmp/vc_redist.x64.exe /quiet /install /norestart && \
#     rm /tmp/vc_redist.x64.exe


# install nuitka in wine with all dlls and stuff
COPY ./requirements* /tmp/repo/
RUN wine python -m pip install --upgrade pip && \
    wine python -m pip install -r /tmp/repo/requirements_nuitka.txt

RUN wine python -m pip install -r /tmp/repo/requirements_nuitka.txt
RUN wine python -m pip install -r /tmp/repo/requirements.txt

# ENV WINEDLLOVERRIDES="ucrtbase=n,builtin;vcruntime140=n,builtin;msvcp140=n,builtin;api-ms-win-crt-math-l1-1-0=n"
# ENV NUITKA_ALLOW_NON_INTERACTIVE_DOWNLOADS=1
COPY ./* /tmp/repo/
RUN chmod +x /tmp/repo/warmup_nuitka_cache.sh && /tmp/repo/warmup_nuitka_cache.sh