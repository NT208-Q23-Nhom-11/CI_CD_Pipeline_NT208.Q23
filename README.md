# CI/CD Pipeline cho Flask Web Application

Do an NT208.Q23.ANTT mo phong pipeline CI/CD cho ung dung Flask co staging, kiem thu tu dong, Docker image tren GHCR, smoke test va rollback.

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

## 1. Gioi Thieu De Tai

Muc tieu cua project la xay dung mot quy trinh DevOps thu gon nhung co du cac buoc cot loi:

- Kiem tra chat luong source bang Flake8.
- Chay unit test va integration test bang Pytest.
- Build Docker image va tag bang full commit SHA.
- Push image len GitHub Container Registry.
- Deploy tu dong len staging khi co push vao `develop`.
- Smoke test endpoint `/health` sau deploy.
- Rollback ve image tag truoc do neu smoke test fail.
- Quan ly secret qua GitHub Secrets, khong commit secret that.

## 2. Cong Nghe Dung

- Python 3.11
- Flask 3.1.3
- Pytest 9.0.3
- Flake8 7.0.0
- Docker va Docker Compose
- GitHub Actions
- GitHub Container Registry
- Bash scripts cho deploy, smoke test va rollback

## 3. Cau Truc Thu Muc

```text
.github/workflows/
  ci.yml                  # CI: lint, unit test, integration test, summary
  cd.yml                  # CD: build, push, deploy, smoke test, rollback
app/
  __init__.py             # Flask app factory
  config.py               # Config qua environment variables
  routes.py               # API endpoints
scripts/
  deploy.sh               # Deploy image moi len staging
  rollback.sh             # Rollback ve previous image tag
  smoke_test.sh           # Retry /health va tra ve pass/fail
tests/
  conftest.py             # Pytest fixtures
  test_unit.py            # Unit tests
  test_integration.py     # Integration tests
docs/
  demo-checklist.md       # Checklist evidence D1-D4
  pipeline-measurement.md # Bang do thoi gian pipeline
.dockerignore             # Loai context, cache, secret khoi Docker build
.env.example              # Mau bien moi truong, khong chua secret that
Dockerfile                # Docker image Python 3.11 non-root
docker-compose.yml        # Staging runtime va healthcheck
requirements.txt          # Python dependencies
run.py                    # Entry point Flask app
```

## 4. Cach Chay Local

Tao moi truong Python va cai dependency:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Tren Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Chay app:

```bash
export FLASK_ENV=development
export APP_VERSION=local-dev
python run.py
```

Kiem tra:

```bash
curl http://localhost:5000/health
curl http://localhost:5000/
```

## 5. Cach Chay Test Va Lint

```bash
python -m pytest -q
python -m pytest tests/test_unit.py -v
python -m pytest tests/test_integration.py -v
python -m flake8 app tests
```

Test suite hien cover cac endpoint chinh: `/`, `/health`, `GET /api/items`, `GET /api/items/<id>`, `POST /api/items`, case 400 va case 404.

## 6. Cach Build Docker Local

```bash
docker build -t cicd-pipeline-nt208:local-dev .
```

Chay bang Docker Compose:

```bash
IMAGE_TAG=local-dev REGISTRY_IMAGE=cicd-pipeline-nt208 docker compose up -d
docker compose ps
curl http://localhost:5000/health
docker compose down
```

Dockerfile chi copy `requirements.txt`, `app/` va `run.py`; cac file `.context/`, cache, zip, secret va `.env` bi loai bang `.dockerignore`.

## 7. Branching Strategy

Project dung GitFlow don gian:

- `main`: nhanh on dinh, dung cho ban nop/demo cuoi.
- `develop`: nhanh tich hop, CI/CD chay chinh.
- `feature/*`: nhanh lam tung task.

Quy trinh de xuat:

```bash
git checkout develop
git checkout -b feature/<ten-task>
git push origin feature/<ten-task>
```

Mo pull request vao `develop`. CI phai pass truoc khi merge. Push vao `develop` se kich hoat CD.

## 8. CI Pipeline Flow

File: `.github/workflows/ci.yml`

Trigger:

- `push` vao `develop`
- `pull_request` vao `develop` hoac `main`

Steps:

1. Checkout source.
2. Setup Python 3.11 va cache pip.
3. Install dependencies.
4. Run `flake8 app tests`.
5. Run `pytest tests/test_unit.py -v`.
6. Run `pytest tests/test_integration.py -v`.
7. Ghi CI summary vao `$GITHUB_STEP_SUMMARY`, gom commit, status va duration.

CI dung `permissions: contents: read, pull-requests: read`.

## 9. CD Pipeline Flow

File: `.github/workflows/cd.yml`

Trigger:

- `push` vao `develop`

Job `build-and-push`:

1. Resolve image name: `ghcr.io/<owner>/<repo>`.
2. Login GHCR bang `GITHUB_TOKEN`.
3. Pull `latest` de lam build cache neu co.
4. Build Docker image voi 2 tag:
   - full commit SHA: `${{ github.sha }}`
   - `latest`
5. Push ca 2 tag len GHCR.
6. Ghi CD build summary.

Job `deploy-and-test`:

1. SSH vao staging bang `STAGING_SSH_KEY`.
2. Clone hoac update repo tren staging ve `origin/develop`.
3. Optional login GHCR bang `GHCR_READ_TOKEN` neu package private.
4. Chay `scripts/deploy.sh <full_sha>`.
5. Chay `scripts/smoke_test.sh http://localhost:5000/health` tren staging host.
6. Neu smoke test fail, chay `scripts/rollback.sh`.
7. Chay smoke test lai sau rollback.
8. Ghi CD deploy summary.

Quy uoc hien tai:

- Deploy va rollback dung full SHA, khong dung `latest`.
- `latest` chi dung de quan sat va lam cache build.
- Smoke test retry 5 lan, moi lan cach 5 giay.
- Smoke test trong CD chay tren staging host qua SSH, nen `localhost:5000` la localhost cua staging server.
- `docker-compose.yml` cung co healthcheck bang Python standard library, khong phu thuoc `curl` trong image.

## 10. Cau Hinh GitHub Secrets

Bat buoc:

| Secret | Muc dich |
| --- | --- |
| `STAGING_HOST` | IP hoac hostname staging server |
| `STAGING_USER` | User SSH tren staging server |
| `STAGING_SSH_KEY` | Private key SSH de GitHub Actions ket noi staging |

Tuy chon:

| Secret | Muc dich |
| --- | --- |
| `STAGING_SSH_PORT` | SSH port neu khong dung port mac dinh 22 |
| `GHCR_READ_TOKEN` | Token read-only de staging pull private GHCR image |

Khong dung:

- `STAGING_PASSWORD`: workflow hien tai da chuyen sang SSH key.
- Secret that trong `.env`, Dockerfile, compose hoac source.

## 11. Kich Ban Demo D1-D4

Chi tiet checklist nam trong `docs/demo-checklist.md`.

### D1 - CI Fail

1. Tao branch `feature/demo-ci-fail`.
2. Tao loi co kiem soat, vi du assertion fail trong test hoac loi Flake8.
3. Mo PR vao `develop`.
4. Ghi evidence: PR status do, log step fail, PR bi chan neu branch protection bat.

### D2 - Deploy Pass

1. Sua loi D1.
2. CI xanh tren PR.
3. Merge vao `develop`.
4. CD build/push/deploy xanh.
5. Ghi evidence: GHCR co tag full SHA, staging `/health` tra 200, GitHub summary co duration.

### D3 - Rollback

1. Deploy mot ban co `/health` loi.
2. Smoke test fail.
3. CD goi rollback.
4. Smoke test sau rollback pass.
5. Ghi evidence: log rollback, `.current_tag` quay ve previous tag, `/health` 200.

### D4 - Time Measurement

Ghi lai thoi gian tu GitHub Actions summary va UI:

- CI fail demo.
- CI pass demo.
- CD deploy pass.
- CD rollback demo.

Dung `docs/pipeline-measurement.md` de dien so lieu.

## 12. Troubleshooting

Docker daemon chua chay:

```text
failed to connect to the docker API
```

Xu ly: bat Docker Desktop hoac Docker Engine tren staging host.

Staging pull GHCR image fail:

- Kiem tra package visibility.
- Neu GHCR private, cau hinh `GHCR_READ_TOKEN`.
- Login thu tren staging: `docker login ghcr.io`.

SSH deploy fail:

- Kiem tra `STAGING_HOST`, `STAGING_USER`, `STAGING_SSH_KEY`, `STAGING_SSH_PORT`.
- Dam bao public key tuong ung da nam trong `~/.ssh/authorized_keys` tren staging.

Smoke test fail sau deploy:

- Xem log `scripts/smoke_test.sh`.
- Kiem tra `docker compose ps`.
- Kiem tra `docker logs staging_web_app`.
- Neu rollback thanh cong, log CD se co `Rollback recovered`.

Tag rollback sai:

- Kiem tra state dir tren staging: `$HOME/staging-state/ci-cd-pipeline`.
- `deploy.sh` ghi `.current_tag` va `.previous_tag`.
- `rollback.sh` doc `.previous_tag` va ghi lai `.current_tag`.

