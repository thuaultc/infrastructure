FROM python:3.6-alpine

ENV PYTHONUNBUFFERED 1

WORKDIR /app
COPY . /app

RUN pip install pipenv \
  && pipenv install --deploy

ENTRYPOINT ["pipenv", "run", "python", "install.py"]
