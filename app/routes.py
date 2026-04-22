from flask import Blueprint, jsonify, request
import os

# Dùng Blueprint để đồng bộ với cấu trúc folder app/
main_bp = Blueprint('main', __name__)

items = [{"id": 1, "name": "item1"}]

@main_bp.route("/")
def index():
    # Lấy version từ môi trường để CD pipeline inject vào (FR-005)
    version = os.getenv("APP_VERSION", "dev-local")
    return jsonify({"app": "CI/CD Demo", "version": version})

@main_bp.route("/health")
def health():
    return jsonify({"status": "ok"}), 200

@main_bp.route("/api/items", methods=["GET"])
def get_items():
    return jsonify({"items": items})

@main_bp.route("/api/items/<int:item_id>", methods=["GET"])
def get_item(item_id):
    item = next((i for i in items if i["id"] == item_id), None)
    if item:
        return jsonify(item), 200
    return jsonify({"error": "Not found"}), 404

@main_bp.route("/api/items", methods=["POST"])
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
