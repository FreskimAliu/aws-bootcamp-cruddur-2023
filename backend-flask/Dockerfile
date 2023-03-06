# Build stage
FROM python:3.10-slim-buster AS build

WORKDIR /backend-flask

COPY requirements.txt .
RUN pip3 install --prefix=/install --no-cache-dir -r requirements.txt

COPY . .

# Development stage
FROM python:3.10-slim-buster

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user to run the container
RUN adduser --disabled-password --gecos '' appuser
USER appuser

WORKDIR /backend-flask

COPY --from=build /install /usr/local
COPY --from=build /backend-flask .

ENV FLASK_ENV=development

EXPOSE ${PORT}
CMD ["sh", "run.sh"]
