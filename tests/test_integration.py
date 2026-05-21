def test_index_returns_200(client):
    response = client.get("/")
    assert response.status_code == 200


def test_index_returns_app_metadata(client):
    client.application.config.update({
        "APP_VERSION": "test-version",
        "FLASK_ENV": "testing",
    })

    response = client.get("/")

    assert response.status_code == 200
    assert response.get_json() == {
        "app": "ci-cd-pipeline-azure-vps",
        "version": "test-version",
        "environment": "testing",
    }


def test_health_returns_ok(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_get_items_returns_list(client):
    response = client.get("/api/items")
    assert response.status_code == 200
    data = response.get_json()
    assert "items" in data
    assert isinstance(data["items"], list)


def test_get_item_found(client):
    response = client.get("/api/items/1")

    assert response.status_code == 200
    assert response.get_json() == {"id": 1, "name": "item-1"}


def test_get_item_not_found_returns_404(client):
    response = client.get("/api/items/99999")

    assert response.status_code == 404
    assert response.get_json() == {"error": "Item not found"}


def test_post_item_created(client):
    response = client.post("/api/items", json={"name": "created-by-test"})

    assert response.status_code == 201
    data = response.get_json()
    assert data["name"] == "created-by-test"
    assert isinstance(data["id"], int)


def test_invalid_post_returns_400(client):
    response = client.post("/api/items", json={})

    assert response.status_code == 400
    assert response.get_json() == {"error": "Invalid request"}
