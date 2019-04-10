FROM python:3.6-alpine

RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY model_download.sh .

RUN ./model_download.sh

RUN apk --no-cache --update-cache add gcc gfortran python python-dev py-pip build-base wget freetype-dev libpng-dev openblas-dev

RUN pip install scipy

WORKDIR /app
RUN apk add --no-cache libjpeg-turbo-dev libpng-dev
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

RUN pip install torch_nightly -f https://download.pytorch.org/whl/nightly/cpu/torch_nightly.html

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD gunicorn app:app --bind 0.0.0.0:$PORT --reload
