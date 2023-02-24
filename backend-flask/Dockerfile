FROM python:3.10-slim-buster

RUN apt-get update && apt-get install -y curl

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

ENV FLASK_ENV=development

EXPOSE ${PORT}
CMD ["sh", "run.sh"]