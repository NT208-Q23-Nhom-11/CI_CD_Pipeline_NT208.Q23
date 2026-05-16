FROM python:3.11-slim

RUN useradd -m devops-user
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/
COPY run.py ./run.py

USER devops-user
EXPOSE 5000

CMD ["python", "run.py"]
