FROM rhexa/chromium-driver:alpine-edge

RUN apk update
RUN apk add imagemagick

COPY ./requirements.txt .
RUN pip install -r requirements.txt

ENTRYPOINT [ "/bin/sh" ]
