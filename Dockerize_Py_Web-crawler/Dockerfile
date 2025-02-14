FROM ubuntu:22.04
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    HOME=/root \
    PYENV_ROOT=/root/.pyenv \
    PATH=/root/.pyenv/shims:$PATH \
    PATH=/root/.pyenv/bin:$PATH \
    TradingDB_host=xxxxxxxxxxxxx.region.rds.amazonaws.com \
    TradingDB_pswd=xxxxxxxxxxxxx

WORKDIR /root/poinTrading

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        git \
        bzip2 \
        ca-certificates \        
        python3-pip \
        libnss3 \
        libglib2.0-0 \
	    libgl1 \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://pyenv.run | bash && \
    /root/.pyenv/bin/pyenv install miniconda3-4.3.30 && \
    /root/.pyenv/bin/pyenv global miniconda3-4.3.30 && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pipenv

RUN wget -q http://archive.ubuntu.com/ubuntu/pool/main/libu/libu2f-host/libu2f-udev_1.1.4-1_all.deb ; \
    dpkg -i libu2f-udev_1.1.4-1_all.deb && \
    rm -f libu2f-udev_1.1.4-1_all.deb

RUN mkdir /root/google-chrome ; \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /root/google-chrome/google-chrome-stable_current_amd64.deb; \
    dpkg -i /root/google-chrome/google-chrome-stable_current_amd64.deb ; \
    apt-get update -y && apt-get -f -y install

ADD ./requirements.txt /root/pyrq4dk/

RUN pip install -r /root/pyrq4dk/requirements.txt

CMD ["/bin/bash"]
