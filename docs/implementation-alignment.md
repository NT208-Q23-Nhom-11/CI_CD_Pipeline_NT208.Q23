# Implementation Alignment Notes

File nay ghi lai cac quy uoc implementation hien tai de doi chieu voi SRS, SDD va report.

## Quy Uoc Da Chot Trong Source

| Van de | Implementation hien tai |
| --- | --- |
| Docker image tag chinh | Full commit SHA `${{ github.sha }}` |
| Tag `latest` | Chi dung de quan sat va lam build cache, khong dung deploy/rollback |
| Smoke test retry | 5 lan, moi lan cach 5 giay |
| Smoke test trong CD | Chay tren staging host qua SSH, URL `http://localhost:5000/health` |
| SSH auth | Dung `STAGING_SSH_KEY`, khong dung `STAGING_PASSWORD` |
| GHCR pull tren staging | Optional `GHCR_READ_TOKEN` neu package private |
| Compose healthcheck | Co healthcheck bang Python standard library |
| Rollback state | `$HOME/staging-state/ci-cd-pipeline/.current_tag` va `.previous_tag` |
| Docker cleanup | Khong dung `docker system prune -af` trong deploy/rollback chinh |

## Diem Can Dong Bo Neu Sua SRS/SDD/Report

- Neu tai lieu con noi short SHA 7 ky tu, sua thanh full SHA.
- Neu tai lieu con noi retry 20 lan, sua thanh 5 lan.
- Neu tai lieu con noi SSH password, sua thanh SSH key.
- Neu tai lieu mo ta smoke test chay tu GitHub runner den public IP, sua thanh smoke test chay tren staging host qua SSH.
- Neu tai lieu noi container healthcheck dung `curl`, sua thanh Python standard library hoac ghi ro image khong can cai curl.
