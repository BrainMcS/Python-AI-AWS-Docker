import pytest
from my_python_app import app, utils, database  # Import necessary modules


# Fixture for test client
@pytest.fixture
def client():
    app.config['TESTING'] = True  # Set testing configuration
    with app.test_client() as client:
        yield client


# Mocking the database interaction
class MockDatabase:
    def insert_sentiment(self, text, score):
        """Mocks inserting sentiment, returning a dummy ID."""
        return 1


@pytest.fixture
def mock_db(monkeypatch):
    mock_db = MockDatabase()
    monkeypatch.setattr(database, "insert_sentiment", mock_db.insert_sentiment)
    return mock_db


# Test cases
def test_analyze_sentiment_positive(client, mock_db):
    data = {'text': 'This is a great product!'}
    response = client.post('/sentiment', json=data)
    assert response.status_code == 201
    assert response.json['sentiment']['compound'] > 0
    assert response.json['id'] == 1  # Check if mock ID is returned


def test_analyze_sentiment_negative(client, mock_db):
    data = {'text': 'This is terrible.'}
    response = client.post('/sentiment', json=data)
    assert response.status_code == 201
    assert response.json['sentiment']['compound'] < 0
    assert response.json['id'] == 1  # Check if mock ID is returned


def test_analyze_sentiment_no_text(client, mock_db):
    response = client.post('/sentiment', json={})
    assert response.status_code == 400
    assert response.json['error'] == 'No text provided'


def test_analyze_text_positive():
    scores = utils.analyze_text("I love this!")
    assert scores['compound'] > 0


def test_analyze_text_negative():
    scores = utils.analyze_text("I hate this.")
    assert scores['compound'] < 0


def test_analyze_text_empty():
    scores = utils.analyze_text("")
    assert scores is not None  # Check if handles empty text


def test_health_check(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json["status"] == "ok"