from app import create_app


def test_app_created_successfully():
    app = create_app()
    assert app is not None


def test_health_route_exists():
    app = create_app()
    routes = [rule.rule for rule in app.url_map.iter_rules()]
    assert "/health" in routes
