FROM python:3.11-slim

WORKDIR /usr/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY . .

RUN dbt deps || echo "Dependencies not installed or packages.yml not found"

ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8