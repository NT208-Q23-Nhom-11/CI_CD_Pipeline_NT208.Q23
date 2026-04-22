FROM python:3.11-slim

RUN useradd -m appuser
WORKDIR /home/appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

USER appuser

# Biến môi trường quan trọng để Flask biết chỗ tìm app
ENV FLASK_APP="app:create_app()"
ENV APP_VERSION="1.0.0"

EXPOSE 5000

# Chạy app bằng flask command
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
