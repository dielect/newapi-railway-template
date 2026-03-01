FROM calciumion/new-api:latest

ENV PORT=3000 \
    TZ=Asia/Shanghai

VOLUME ["/data", "/app/logs"]

EXPOSE ${PORT}

CMD ["--log-dir", "/app/logs"]
