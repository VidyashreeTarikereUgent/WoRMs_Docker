FROM node:18

RUN apt-get update

RUN apt-get install -y default-jre-headless

RUN apt-get update && apt-get install -y git

RUN git -C /opt clone https://github.com/TREEcg/connector-architecture.git pipeline

WORKDIR /opt/pipeline
RUN git submodule update --init --recursive
RUN cd processor/sds-processors && npm install && npm run build
RUN cd processor/rml-mapper-processor-ts && npm install && npm run build
RUN cd processor/sds-storage-writer-mongo && npm install && npm run build
RUN cd runner/js-runner && npm install && npm run build
COPY . .

ENTRYPOINT [ "node", "--experimental-specifier-resolution=node", "runner/js-runner/bin/js-runner.js" ]