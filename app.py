from flask import Flask, request, jsonify
import joblib
from flask_cors import CORS

# Load model and vectorizer
model = joblib.load("model/qr_model.pkl")
vectorizer = joblib.load("model/vectorizer.pkl")

app = Flask(__name__)
CORS(app)  # To allow frontend to call from different origin (React)

@app.route("/check-qr", methods=["POST"])
def check_qr():
    data = request.json.get("qr")
    if not data:
        return jsonify({"error": "No QR code data received"}), 400

    try:
        vectorized = vectorizer.transform([data])
        prediction = model.predict(vectorized)[0]
        result = "Benign" if prediction == 1 else "Malicious"
        return jsonify({"result": result})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
