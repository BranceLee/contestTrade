# Phase 1
FROM continuumio/miniconda3:latest AS compile-image
WORKDIR /ContestTrade
COPY requirements.txt .
# RUN conda update conda
RUN conda create -n contesttrade python=3.10

RUN echo "conda activate contesttrade" >> ~/.bashrc
ENV PATH /opt/conda/envs/contesttrade/bin:$PATH

RUN python -m pip install --upgrade pip
RUN python -m pip install -r requirements.txt --no-cache-dir --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install conda-pack:
RUN conda install -c conda-forge conda-pack
# Use conda-pack to create a standalone enviornment in /venv:
RUN conda-pack -n contesttrade --ignore-missing-files -o /tmp/env.tar && \
  mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
  rm /tmp/env.tar
RUN /venv/bin/conda-unpack

# Phase 2
FROM continuumio/miniconda3:latest AS runtime-image

# 设置时区为上海
ENV TZ=Asia/Shanghai
RUN apt-get update && apt-get install -y tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /ContestTrade
COPY . .
COPY --from=compile-image /venv /venv

SHELL ["/bin/bash", "-c"]
ENTRYPOINT source /venv/bin/activate && \
           python -m cli.main run
