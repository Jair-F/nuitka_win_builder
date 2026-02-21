#!/bin/bash


# installing nuitka with mingw
wine python -m pip install -r /tmp/repo/requirements_nuitka.txt
wine python -m pip install -r /tmp/repo/requirements.txt
export NUITKA_CACHE_DIR=/opt/nuitka_cache
wine python -m nuitka --version --assume-yes-for-downloads --mingw64

touch /tmp/repo/dummy.ico
wine python -m nuitka --standalone --onefile --mingw64 --assume-yes-for-downloads \
    --include-runtime-dependencies \
    --experimental=new-dll-tool \
    --windows-icon-from-ico=/tmp/repo/dummy.ico \
    --company-name="MyCompany" \
    --product-name="OfflineCompiler" \
    --file-version=1.0.0.0 \
    --product-version=1.0.0.0 \
    --file-description="Warmup Build" \
    --copyright="2024" \
    --output-dir=/tmp/output /tmp/repo/warmup.py

# compile for the big ones without console
wine python -m nuitka --standalone --onefile --mingw64 --assume-yes-for-downloads \
    --include-runtime-dependencies \
    --experimental=new-dll-tool \
    --plugin-enable=torch \
    --plugin-enable=numpy \
    --plugin-enable=qt-plugins \
    --plugin-enable=matplotlib \
    --plugin-enable=anti-bloat \
    --windows-console-mode=disable \
    --output-dir=/tmp/output warmup.py

# cleanup - only keep nuitka and whats needed for it
wine python -m pip uninstall -r /tmp/requirements.txt -y


rm -rfd /tmp/output
