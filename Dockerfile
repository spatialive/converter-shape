###############################################
# Production Image
###############################################
FROM registry.lapig.iesa.ufg.br/lapig-images-homol/app_converter_shape:base

WORKDIR /APP

SHELL ["/bin/bash", "-c"]

# Clone app and npm install on server
ENV URL_TO_APPLICATION_GITHUB="https://github.com/spatialive/converter-shape.git"
ENV BRANCH="main"
    
RUN if [ -d "/APP/converter-shape" ]; then rm -Rf /APP/converter-shape; fi \
    && apt-get update && apt-get install -y git curl && mkdir -p /APP && cd /APP && git clone -b ${BRANCH} ${URL_TO_APPLICATION_GITHUB} \
    && rm -rf /var/lib/apt/lists/* \
    && cd /APP/converter-shape/client && npm ci \
    && ng build 
CMD bash -c "cd /APP/converter-shape/server && ./start.sh"
