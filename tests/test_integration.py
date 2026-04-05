import pytest

from app import create_app


@pytest.fixture
def client():
    app = create_app()
    return app.test_client()


def test_health(client):
    res = client.get("/health")
    assert res.status_code == 200
    assert res.json == {"status": "ok"}
