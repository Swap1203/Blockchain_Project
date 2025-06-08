import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib
import os

# Correct path for Windows (raw string to avoid \ escape issues)
csv_path = r"C:/Users/Siddhi/OneDrive/Desktop/qr-ml-backend/dataset/QR_Code_dataset.csv"
model_dir = r"C:/Users/Siddhi/OneDrive/Desktop/qr-ml-backend/model"

# Create model directory if it doesn't exist
os.makedirs(model_dir, exist_ok=True)

# Load dataset
df = pd.read_csv(csv_path)

# Features and labels
X = df['qr_code']
y = df['label']

# Vectorize QR data
vectorizer = TfidfVectorizer()
X_vec = vectorizer.fit_transform(X)

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(X_vec, y, test_size=0.2, random_state=42)

# Train model
model = LogisticRegression()
model.fit(X_train, y_train)

# Save model and vectorizer
joblib.dump(model, os.path.join(model_dir, "qr_model.pkl"))
joblib.dump(vectorizer, os.path.join(model_dir, "vectorizer.pkl"))

print("✅ Model and vectorizer saved!")
