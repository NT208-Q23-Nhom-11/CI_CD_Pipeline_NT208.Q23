from flask import jsonify, request


items = [{"id": 1, "name": "item1"}]


def register_routes(app):

    @app.route("/")
    def index():
        return jsonify({"app": "CI/CD Demo", "version": "dev"})

    @app.route("/health")
    def health():
        return jsonify({"status": "ok"}), 200

    @app.route("/api/items")
    def get_items():
        return jsonify({"items": items})

    @app.route("/api/items/<int:item_id>")
    def get_item(item_id):
        for item in items:
            if item["id"] == item_id:
                return jsonify(item)
        return jsonify({"error": "Not found"}), 404

    @app.route("/api/items", methods=["POST"])
    def add_item():
        data = request.get_json()
        if not data or "name" not in data:
            return jsonify({"error": "Bad request"}), 400

        new_item = {
            "id": len(items) + 1,
            "name": data["name"]
        }
        items.append(new_item)
        return jsonify(new_item), 201
