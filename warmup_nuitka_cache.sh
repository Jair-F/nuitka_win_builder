#!/bin/bash
set -e

# Dockerfile: kniwase/wine-python-nuitka:3.10
# working PyQt:
# PyQt6==6.6.0
# PyQt6-Qt6==6.6.0
# if upgrading nuitka also do one fake build to download mingw

# installing nuitka with mingw
# wine python -m pip install -r /tmp/repo/requirements_nuitka.txt
# wine python -m pip install -r /tmp/repo/requirements.txt
wine python -m nuitka --version --assume-yes-for-downloads --clang

mkdir -p /tmp/repo/
cp warmup.py /tmp/repo
touch /tmp/repo/dummy.ico
wine python -m nuitka \
    --standalone --onefile \
    --mingw64 --lto=no \
    --assume-yes-for-downloads \
    --windows-icon-from-ico=/tmp/repo/dummy.ico \
    --company-name="MyCompany" \
    --product-name="OfflineCompiler" \
    --file-version=1.0.0.0 \
    --product-version=1.0.0.0 \
    --file-description="Warmup Build" \
    --copyright="2024" \
    --enable-plugin=pyqt6 \
    --enable-plugin=tk-inter \
    --windows-console-mode=disable \
    --output-dir=/tmp/output /tmp/repo/warmup.py

# cleanup - only keep nuitka and whats needed for it
# wine python -m pip uninstall -r /tmp/repo/requirements.txt -y
wine python -m pip cache purge

rm -rfd /tmp/output
