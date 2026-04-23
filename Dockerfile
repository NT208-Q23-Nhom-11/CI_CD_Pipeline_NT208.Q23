# Sử dụng Python 3.11 chuẩn dự án
FROM python:3.11-slim

# Bảo mật: Chạy bằng user không phải root [cite: 87]
RUN useradd -m devops-user
WORKDIR /app

# Cài dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy mã nguồn
COPY . .

USER devops-user
EXPOSE 5000

# Lệnh chạy Flask theo cấu trúc project
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0","run.py"]