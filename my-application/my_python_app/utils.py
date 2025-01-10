from nltk.sentiment.vader import SentimentIntensityAnalyzer

# Initialize the sentiment analyzer (can be reused across multiple requests)
analyzer = SentimentIntensityAnalyzer()

def analyze_text(text):
    """Analyzes the sentiment of the given text using VADER.

    Args:
        text: The text to analyze.

    Returns:
        A dictionary containing the sentiment scores, or None if an error occurs.
    """
    try:
        scores = analyzer.polarity_scores(text)
        return scores
    except Exception as e:  # Handle any exceptions during analysis
        print(f"Error in sentiment analysis: {e}")  # Log for debugging
        return None