from flask import jsonify, request


ITEMS = [
    {"id": 1, "name": "item-1"},
    {"id": 2, "name": "item-2"},
]


def register_routes(app):
    @app.get("/")
    def index():
        return jsonify({
            "app": "ci-cd-pipeline-azurevps",
            "version": app.config.get("APP_VERSION", "dev"),
            "environment": app.config.get("FLASK_ENV", "development")
        }), 200

    @app.get("/health")
    def health(): 
        return jsonify({"status": "ok"}), 200

    @app.get("/api/items")
    def get_items():
        return jsonify({"items": ITEMS}), 200

    @app.get("/api/items/<int:item_id>")
    def get_item(item_id):
        item = next((item for item in ITEMS if item["id"] == item_id), None)
        if item is None:
            return jsonify({"error": "Item not found"}), 404
        return jsonify(item), 200

    @app.post("/api/items")
    def create_item():
        data = request.get_json(silent=True)

        if not data or "name" not in data:
            return jsonify({"error": "Invalid request"}), 400

        new_item = {
            "id": len(ITEMS) + 1,
            "name": data["name"]
        }
        ITEMS.append(new_item)

        return jsonify(new_item), 201
