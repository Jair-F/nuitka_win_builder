#!/bin/bash


# installing nuitka with mingw
wine python -m pip install -r /tmp/repo/requirements_nuitka.txt
wine python -m pip install -r /tmp/repo/requirements.txt
wine python -m nuitka --version --assume-yes-for-downloads --mingw64

touch /tmp/repo/dummy.ico
wine python -m nuitka --standalone --onefile --mingw64 --lto=no --assume-yes-for-downloads \
    --windows-icon-from-ico=/tmp/repo/dummy.ico \
    --company-name="MyCompany" \
    --product-name="OfflineCompiler" \
    --file-version=1.0.0.0 \
    --product-version=1.0.0.0 \
    --file-description="Warmup Build" \
    --copyright="2024" \
    --output-dir=/tmp/output /tmp/repo/warmup.py

# compile for the big ones without console adn without expermintal-dll-tool
wine python -m nuitka --standalone --onefile --mingw64 --lto=no --assume-yes-for-downloads \
    --plugin-enable=pyqt6 \
    --enable-plugin=tk-inter \
    --plugin-enable=matplotlib \
    --plugin-enable=pickleable-itertools \
    --plugin-enable=anti-bloat \
    --windows-console-mode=disable \
    --output-dir=/tmp/output /tmp/repo/warmup.py

# cleanup - only keep nuitka and whats needed for it
wine python -m pip uninstall -r /tmp/repo/requirements.txt -y
wine python -m pip cache purge

rm -rfd /tmp/output
