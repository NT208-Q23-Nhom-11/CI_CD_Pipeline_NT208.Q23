# Pipeline Measurement

Bang nay dung de dien so lieu that sau khi chay GitHub Actions. Duration co the lay tu GitHub Actions UI hoac tu `$GITHUB_STEP_SUMMARY`.

## Bang Do Thoi Gian

| Lan chay | Commit SHA | Workflow | Ket qua | Duration UI | Duration summary | Ghi chu |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | TBD | CI | Fail | TBD | TBD | Commit loi co kiem soat |
| D2-CI | TBD | CI | Pass | TBD | TBD | PR fix loi |
| D2-CD | TBD | CD | Pass | TBD | TBD | Deploy staging thanh cong |
| D3 | TBD | CD | Rollback recovered | TBD | TBD | Smoke test fail, rollback pass |

## Cach Lay So Lieu

1. Vao GitHub repository.
2. Mo tab Actions.
3. Chon workflow run tuong ung.
4. Ghi duration hien tren UI.
5. Mo workflow summary de lay duration do workflow ghi.
6. Doi chieu voi log step neu can.

## So Sanh Voi Deploy Thu Cong

| Tieu chi | CI/CD | Deploy thu cong |
| --- | --- | --- |
| Build image | Tu dong, tag full SHA | De sai tag hoac quen build lai |
| Test truoc merge | Bat buoc qua CI | Phu thuoc nguoi thao tac |
| Deploy staging | Tu dong khi push vao `develop` | Can SSH va chay lenh tay |
| Rollback | Doc previous tag va smoke test lai | De nham version neu khong ghi tag |
| Audit log | Co GitHub Actions log | Kho truy vet neu thao tac truc tiep |

Nhan xet can dien sau demo:

- CI/CD giam loi thao tac lap lai.
- Docker image full SHA giup truy vet version ro rang.
- Smoke test va rollback tu dong giup phat hien loi som hon deploy thu cong.
- Manual deploy co the nhanh trong demo nho, nhung kho kiem soat khi can rollback dung version.
