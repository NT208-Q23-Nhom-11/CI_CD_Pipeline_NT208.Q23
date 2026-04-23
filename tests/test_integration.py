def test_get_index(client):
    res = client.get('/')
    assert res.status_code == 200
    assert "version" in res.get_json()

def test_get_health(client):
    res = client.get('/health')
    assert res.status_code == 200
    assert res.get_json() == {"status": "ok"}

def test_get_items(client):
    res = client.get('/api/items')
    assert res.status_code == 200
    assert isinstance(res.get_json()["items"], list)
