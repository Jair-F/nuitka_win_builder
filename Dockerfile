FROM kniwase/wine-python-nuitka:3.10

# COPY ./requirements* /tmp/repo/
RUN wine python -m pip install --upgrade pip
RUN wine python -m nuitka --version --assume-yes-for-downloads --mingw64
