# Demo Checklist D1-D4

Dung file nay de chuan bi evidence truoc khi demo cuoi ky. Moi muc nen co anh chup man hinh hoac log ro rang.

## D1 - CI Fail

- [ ] Branch demo: `feature/demo-ci-fail`.
- [ ] Pull request vao `develop`.
- [ ] GitHub Actions CI co dau X do.
- [ ] Log chi ro step fail: `Run flake8`, `Run unit tests`, hoac `Run integration tests`.
- [ ] PR bi chan merge neu branch protection dang bat.
- [ ] Ghi commit SHA cua commit fail.

Evidence can chup:

- PR checks bi fail.
- GitHub Actions log tai step fail.
- Man hinh branch protection/PR blocked neu co.

## D2 - Deploy Pass

- [ ] Commit fix da lam CI xanh.
- [ ] PR merge vao `develop`.
- [ ] CD workflow xanh.
- [ ] GHCR co image tag full commit SHA.
- [ ] GHCR co tag `latest`.
- [ ] Staging `/health` tra HTTP 200 va body `{"status":"ok"}`.
- [ ] `GET /` hien thi `version` trung voi image tag/full SHA da deploy.
- [ ] GitHub Actions summary co duration.

Evidence can chup:

- CI xanh tren PR.
- CD xanh sau merge.
- GHCR package tags.
- Ket qua `curl http://<staging-host>:5000/health`.
- CD summary.

## D3 - Rollback

- [ ] Deploy truoc do dang co tag A healthy.
- [ ] Deploy tag B co loi `/health`.
- [ ] Smoke test fail.
- [ ] CD log hien `Starting rollback`.
- [ ] `scripts/rollback.sh` deploy lai previous tag.
- [ ] Post-rollback smoke test pass.
- [ ] CD log hien `Rollback recovered`.
- [ ] Tren staging, `.current_tag` quay ve tag A.

Lenh kiem tra tren staging:

```bash
cat $HOME/staging-state/ci-cd-pipeline/.current_tag
cat $HOME/staging-state/ci-cd-pipeline/.previous_tag
curl -i http://localhost:5000/health
docker compose ps
```

Evidence can chup:

- Log smoke test fail.
- Log rollback chay.
- Log post-rollback smoke test pass.
- Noi dung `.current_tag`.

## D4 - Pipeline Timing

- [ ] Ghi thoi gian CI fail demo.
- [ ] Ghi thoi gian CI pass demo.
- [ ] Ghi thoi gian CD deploy pass.
- [ ] Ghi thoi gian CD rollback demo.
- [ ] So sanh voi deploy thu cong.

Dung bang trong `docs/pipeline-measurement.md`.

## Final Demo Order

1. Mo PR loi de demo D1.
2. Sua loi, CI pass va merge vao `develop`.
3. Theo doi CD build/push/deploy pass de demo D2.
4. Deploy ban loi `/health` de demo D3 rollback.
5. Mo GitHub Actions summary va bang do thoi gian de demo D4.
