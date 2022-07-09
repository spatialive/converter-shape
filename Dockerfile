###############################################
# Base Image
###############################################
FROM python:3.10-slim as python-base

ENV LAPIG_ENV=${LAPIG_ENV} \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.0.5 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"\
    PYTHONBREAKPOINT="web_pdb.set_trace"

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
###############################################
# Builder Image
###############################################
FROM python-base as builder-base

RUN apt-get update && apt-get install --no-install-recommends -y curl build-essential && \
    pip3 install poetry 

WORKDIR $PYSETUP_PATH
COPY ./server/pyproject.toml ./server/poetry.lock ./

# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
RUN poetry install --no-dev --no-interaction --no-ansi

###############################################
# Production Image
###############################################
FROM python-base as production
COPY --from=builder-base $PYSETUP_PATH $PYSETUP_PATH

WORKDIR /APP

SHELL ["/bin/bash", "-c"]

# Clone app and npm install on server
ENV URL_TO_APPLICATION_GITHUB="https://github.com/spatialive/converter-shape.git"
ENV BRANCH="main"

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.17.3
ENV ANGULAR_VERSION 12.0.5
ENV NVM_VERSION v0.31.2

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


RUN apt-get update && apt-get install -y git curl && mkdir -p /APP && cd /APP && git clone -b ${BRANCH} ${URL_TO_APPLICATION_GITHUB} && \
    rm -rf /var/lib/apt/lists/* && \
    curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash && \
    source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm config set user 0 \
    && npm config set unsafe-perm true \
    && npm install -g @angular/cli@$ANGULAR_VERSION \
    && cd /APP/converter-shape/client && npm ci \
    && ng build 

CMD bash -c "cd /APP/converter-shape/server && ./start.sh"
