# CI_CD_Pipeline_NT208.Q23

Giai đoạn 1: Chốt chặn CI (Pull Request)

Khi bạn tạo Pull Request vào develop, GitHub Actions đọc file ci.yml.

Lệnh flake8 sẽ chạy, đọc cấu hình từ .flake8 (bỏ qua lỗi dòng quá dài) và pass xanh lét vì code Flask của bạn rất gọn.

Lệnh pytest sẽ chạy, dùng conftest.py dựng app ảo lên và gọi các hàm trong test_integration.py và test_unit.py. Endpoint /health trả về ok, danh sách items có dữ liệu. => CI PASS (Tích xanh).

Giai đoạn 2: Đóng gói & Push Image (Merge into develop)

Bạn bấm nút "Merge Pull Request", file cd.yml kích hoạt.

Hành động Set Image Tag sẽ cắt 7 ký tự đầu của commit git (ví dụ: abc1234).

Docker đọc Dockerfile, cài requirements.txt, và đóng gói app lại.

Image được đẩy lên GitHub Container Registry với tên ghcr.io/...:abc1234. => BUILD PASS.

Giai đoạn 3: Triển khai & Smoke Test (Server Staging)

cd.yml đăng nhập SSH vào server và gọi scripts/deploy.sh abc1234 ....

Script tải image mới về, gán biến IMAGE_TAG=abc1234 rồi truyền cho docker-compose.yml.

Docker Compose chạy container lên. Ở bước này, file routes.py của bạn dùng os.getenv("APP_VERSION") sẽ nhận được đúng giá trị abc1234.

Vòng lặp test tự động gọi http://localhost:5000/health. App trả về ok. => DEPLOY THÀNH CÔNG.

Giai đoạn 4: Kịch bản rủi ro (Giả sử Deploy lỗi)

Nếu app bị crash, vòng lặp test không thấy chữ ok.

Lập tức scripts/rollback.sh được gọi. Nó lấy file .previous_tag ra và chạy lại image cũ trong nháy mắt. Cứu thua xuất sắc!
