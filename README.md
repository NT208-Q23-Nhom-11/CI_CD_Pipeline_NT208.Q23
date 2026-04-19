# Pipeline CI/CD cho Web Application với Staging, Kiểm thử tự động và Rollback

## Giới thiệu

Đây là đồ án môn Lập Trình Ứng Dụng Web (NT208) với mục tiêu xây dựng một pipeline CI/CD cho ứng dụng web đơn giản, hỗ trợ kiểm thử tự động, triển khai lên môi trường staging và rollback khi phát hiện lỗi sau deploy.

Dự án mô phỏng một quy trình DevOps thu gọn nhưng bám sát các thành phần cốt lõi trong thực tế: lint, unit test, integration test, build Docker image, push registry, deploy staging, smoke test và rollback.

## Giảng viên hướng đẫn

- Ths. Nghi Hoàng Khoa
  

## Thực hiện bởi nhóm 11 gồm:

- Hồ Ngọc Vương Thương - 24521749
  
- Phạm Trần Anh Tuấn - 24521939
  
- Võ Đình Hoàng Tiến - 24521783
  
- Hà Võ Đức Thiện - 24521658
  

## Lớp

NT208.Q23.ANTT

---

## 1. Mục tiêu dự án

Hệ thống được xây dựng nhằm đạt các mục tiêu chính sau:

- Tự động kiểm tra chất lượng mã nguồn bằng **Flake8**
- Tự động chạy **Unit Test** và **Integration Test** bằng **Pytest**
- Đóng gói ứng dụng bằng **Docker**
- Tự động build và push image lên **GitHub Container Registry (GHCR)**
- Tự động deploy ứng dụng lên môi trường **staging**
- Thực hiện **smoke test** thông qua endpoint `/health`
- Tự động **rollback** về phiên bản trước nếu deployment thất bại
- Quản lý thông tin nhạy cảm an toàn bằng **GitHub Secrets**

---

## 2. Công nghệ sử dụng

- **Python 3.11** (phiên bản chuẩn của project)
- **Flask 3.0.0**
- **Pytest 8.0.0**
- **Flake8 7.0.0**
- **Docker / Docker Compose**
- **GitHub Actions**
- **GitHub Container Registry (GHCR)**

> Lưu ý: môi trường local cá nhân có thể khác, nhưng môi trường chuẩn của project và pipeline được thống nhất là **Python 3.11**.

---

## 3. Cấu trúc thư mục

```text
.github/
  workflows/
    ci.yml                  # CI pipeline: lint + unit test + integration test
    cd.yml                  # CD pipeline: build, push, deploy, smoke test, rollback

app/
  __init__.py               # Flask app factory
  config.py                 # Quản lý cấu hình theo biến môi trường
  routes.py                 # Định nghĩa các API endpoint

scripts/
  deploy.sh                 # Script deploy image mới lên staging
  rollback.sh               # Script rollback về image tag trước đó

tests/
  conftest.py               # Pytest fixtures
  test_unit.py              # Unit tests
  test_integration.py       # Integration tests

.flake8                     # Cấu hình Flake8
.gitignore                  # Các file/thư mục bỏ qua
.env.example                # File mẫu cho biến môi trường
docker-compose.yml          # Định nghĩa môi trường staging
Dockerfile                  # Đóng gói ứng dụng thành Docker image
README.md                   # Tài liệu hướng dẫn dự án
requirements.txt            # Danh sách dependencies Python
