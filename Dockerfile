FROM python:3.9-alpine3.13
LABEL maintainer="ashitaaswal"

# Avoid buffering Python output
ENV PYTHONUNBUFFERED=1

# Set working directory and copy files
WORKDIR /app
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Install dependencies and setup
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

# Update PATH to include virtual environment binaries
ENV PATH="/py/bin:$PATH"

# Expose application port
EXPOSE 8000

# Run as a non-root user
USER django-user
