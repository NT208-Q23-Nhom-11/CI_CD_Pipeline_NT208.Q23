import pytest
def test_index_returns_200(client):
    response = client.get("/")
    assert response.status_code == 200

from app import create_app

def test_health_returns_ok(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}

@pytest.fixture
def client():
    app = create_app()
    return app.test_client()


def test_health(client):
    res = client.get("/health")
    assert res.status_code == 200
    assert res.json == {"status": "ok"}
def test_get_items_returns_list(client):
    response = client.get("/api/items")
    assert response.status_code == 200
    data = response.get_json()
    assert "items" in data
    assert isinstance(data["items"], list)
