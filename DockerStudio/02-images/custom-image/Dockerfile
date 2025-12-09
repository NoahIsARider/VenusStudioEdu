FROM python:3.11-slim

LABEL maintainer="dockerstudio@example.com"
LABEL description="Simple Python application demo"

WORKDIR /app

# 复制应用文件
COPY app.py .

# 设置环境变量
ENV PYTHONUNBUFFERED=1

CMD ["python3", "app.py"]
