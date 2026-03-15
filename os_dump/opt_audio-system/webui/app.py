from flask import Flask, render_template, jsonify, request
import subprocess
import json
import os

app = Flask(__name__)

STATE_FILE = "/opt/audio-system/manager/state.json"
MANAGER = "/opt/audio-system/manager/audio_manager.sh"
AUTO_SWITCH_FLAG = "/opt/audio-system/manager/auto_switch.enabled"

def get_state():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE) as f:
            try:
                return json.load(f)
            except Exception:
                return {"source": "unknown"}
    return {"source": "unknown"}

def is_auto_switch_enabled():
    return os.path.exists(AUTO_SWITCH_FLAG)

@app.route("/")
def index():
    return render_template("index.html",
                           state=get_state(),
                           auto_switch=is_auto_switch_enabled())

@app.route("/api/source/<src>", methods=["POST"])
def set_source(src):
    if src not in ["spotify", "bluetooth", "linein", "dlnainit"]:
        return jsonify({"status": "error", "error": "invalid source"}), 400

    subprocess.call([MANAGER, src])
    return jsonify({"status": "ok", "source": src})

@app.route("/api/state")
def state():
    s = get_state()
    s["auto_switch"] = is_auto_switch_enabled()
    return jsonify(s)

@app.route("/api/auto_switch", methods=["POST"])
def auto_switch():
    data = request.get_json(silent=True) or {}
    enable = data.get("enable", None)

    if enable is None:
        return jsonify({"status": "error", "error": "missing 'enable'"}), 400

    if enable:
        open(AUTO_SWITCH_FLAG, "w").close()
    else:
        if os.path.exists(AUTO_SWITCH_FLAG):
            os.remove(AUTO_SWITCH_FLAG)

    return jsonify({"status": "ok", "auto_switch": is_auto_switch_enabled()})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
