FROM python:3.9-slim-buster

WORKDIR /app
COPY requirements.txt .

RUN pip3 install -r requirements.txt

# Copy just your application code (not the entire directory which includes tests)
COPY my_python_app/ /app/my_python_app/
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "my_python_app.app:app"] # Start gunicorn