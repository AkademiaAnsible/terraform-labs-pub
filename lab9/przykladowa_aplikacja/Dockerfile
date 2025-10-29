# Simple Hello World HTTP server
FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PORT=80
WORKDIR /app
COPY app.py /app/app.py
EXPOSE 80
CMD ["python", "/app/app.py"]
