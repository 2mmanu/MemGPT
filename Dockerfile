FROM quay.io/fedora/python-312

# https://github.com/confluentinc/librdkafka
USER 0
RUN yum install -y librdkafka-devel
USER 1001

RUN pip install confluent-kafka
RUN pip install agentlink==0.1.1.dev1

RUN pip install poetry==1.8.2

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN poetry lock --no-update
RUN poetry install

EXPOSE 8083
COPY ./memgpt /memgpt
CMD ./memgpt/server/startup.sh