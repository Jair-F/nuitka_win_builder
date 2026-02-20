#!/bin/bash

wine python -m pip install -r requirements.txt
wine python -m nuitka --standalone --onefile --jobs=$(nproc) --onefile-no-compression \
    --windows-icon-from-ico=icon/icon.ico -onefile-windows-splash-screen-image=data/splash.png  \
    --mingw64 --lto=no  --remove-output --windows-console-mode=disable \
    src/app.py -o app_uncompressed.exe
wine python -m nuitka --standalone --onefile --jobs=$(nproc) \
    --windows-icon-from-ico=icon/icon.ico -onefile-windows-splash-screen-image=data/splash.png  \
    --mingw64 --lto=no  --remove-output --windows-console-mode=disable \
    src/app.py -o app_compressed.exe

# --report
# --remove-output --assume-yes-for-downloads
# faster - no compression: --onefile-no-compression