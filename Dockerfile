FROM continuumio/miniconda3:4.8.2

WORKDIR /app

ADD . /app

ARG REACT_APP_MODEL_DEPLOYMENT_URL
ARG REACT_APP_MODEL_INFERENCE_API

ENV REACT_APP_MODEL_DEPLOYMENT_URL ${REACT_APP_MODEL_INFERENCE_API}
ENV REACT_APP_MODEL_INFERENCE_API ${REACT_APP_MODEL_INFERENCE_API}
#Ri pip install --upgrade pip
RUN apt-get update 
    # install prequired modules to support install of mlflow and related components
RUN apt-get install -y default-libmysqlclient-dev build-essential curl \
    # cmake and protobuf-compiler required for onnx install
    cmake protobuf-compiler 
    # install required python packages
RUN pip install --upgrade pip
RUN pip install --use-deprecated=legacy-resolver -r dev-requirements.txt --no-cache-dir 
RUN pip install --use-deprecated=legacy-resolver -r test-requirements.txt --no-cache-dir
    # install mlflow in editable form
RUN pip install --use-deprecated=legacy-resolver --no-cache-dir -e .
    # mkdir required to support install openjdk-11-jre-headless
RUN mkdir -p /usr/share/man/man1 && apt-get install -y openjdk-11-jre-headless 
    # install npm for node.js support
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - 
RUN apt-get update && apt-get install -y nodejs 
RUN cd mlflow/server/js && \
    npm install && \
    npm run build
