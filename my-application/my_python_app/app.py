from flask import Flask, request, jsonify
from my_python_app import database, utils  # Import the utils module

# Download VADER lexicon (only needed once)
nltk.download('vader_lexicon')

app = Flask(__name__)

# Initialize the VADER sentiment analyzer
analyzer = SentimentIntensityAnalyzer()


@app.route('/sentiment', methods=['POST'])
def analyze_sentiment():
    """Analyzes sentiment of provided text and stores results in the database."""
    try:
        data = request.get_json()
        text = data.get('text', '')
        if not text:
            return jsonify({'error': 'No text provided'}), 400

        # Analyze sentiment using the utility function
        scores = utils.analyze_text(text)
        if scores is None:  # Handle errors from the sentiment analysis function
            return jsonify({'error': 'Sentiment analysis failed'}), 500

        # Insert into database and get the ID
        id = database.insert_sentiment(text, scores['compound'])
        if id is None:  # Check if insertion failed
            return jsonify({'error': 'Database error'}), 500

        response_data = {
            'id': id,
            'sentiment': scores
        }
        return jsonify(response_data), 201

    except nltk.exceptions.LookupError as e:
        print(f"NLTK Lookup Error: {e}")  # Log the error
        nltk.download(str(e).split(',')[0].strip())  # Attempt to download resources
        return jsonify({'error': 'Resource not found, attempting download. Resubmit request.'}), 500

    except Exception as e:  # Catch other exceptions
        print(f"An error occurred: {e}")  # Log the error
        return jsonify({'error': 'An unexpected error occurred'}), 500


@app.route('/health', methods=['GET'])
def health_check():
    """Checks the health of the application and database connection."""
    try:
        # Test database connection (you might perform a simple query here)
        with database.db_pool.getconn() as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")  # Simple test query
        return jsonify({'status': 'ok'}), 200  # Healthy

    except Exception as e:
        print(f"Health check failed: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500  # Not healthy


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)  # For local development/testing