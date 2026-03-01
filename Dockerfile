FROM calciumion/new-api:latest

ENV PORT=3000 \
    TZ=Asia/Shanghai

EXPOSE ${PORT}
