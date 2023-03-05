FROM tiangolo/uvicorn-gunicorn-fastapi:python3.11

ENV API_KEY="2f5ae96c-b558-4c7b-a590-a501ae1c3f6c"

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./app /app

RUN echo ${API_KEY}

RUN env