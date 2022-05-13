FROM python:3.10.4-alpine3.15 as python-builder

COPY ["./requirements.txt", "/"]

RUN apk add --no-cache --virtual .build-deps alpine-sdk \
    && adduser --disabled-password --home /app python \
    && chown -R python.python /app 

ENV PATH "/app/.local/bin:${PATH}"

RUN cd /app \
    && pip3 install --upgrade pip

USER python
RUN pip3 install -r requirements.txt \
    && rm -rf /app/.cache 

USER root
RUN rm -rf .build-deps \
           /requirements.txt


FROM scratch

COPY --from=python-builder ["/", "/"]
WORKDIR "/app"
USER python
ENV PATH "/app/.local/bin:${PATH}"

CMD ["python"]

