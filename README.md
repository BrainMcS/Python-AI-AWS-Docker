# Python-AI-AWS-Docker

For educational purposes, this project demonstrates an AWS EC2 deployment for a Python AI web application, using AWS Redshift as a database and AWS Elastic Load Balancing for high availability. The application is containerized using Docker and deployed across two environments: production (prod) and development (dev).

Security is a top priority, utilizing AWS AMIs, IAM roles, and AWS Secrets Manager for sensitive data management. Observability is achieved through Datadog for APM and other monitoring capabilities.

## Tech Stack

1.  **Flask:**
    *   Purpose: A micro web framework for Python.
    *   Reason for Use: Lightweight, easy to set up, and well-suited for building APIs and web applications.

2.  **NLTK (VADER):**
    *   Purpose: Used for sentiment analysis of text data.
    *   Reason for Use: A lexicon and rule-based sentiment analysis tool specifically attuned to sentiments expressed in social media.

3.  **Psycopg2:**
    *   Purpose: A PostgreSQL adapter for Python.
    *   Reason for Use: The most popular PostgreSQL database adapter for Python, offering robust features and efficient interaction with databases like Amazon Redshift.

4.  **Amazon Redshift:**
    *   Purpose: A fully managed, petabyte-scale data warehouse service.
    *   Reason for Use: Optimized for data analysis and can handle large volumes of data efficiently.

5.  **Amazon ECR (Elastic Container Registry):**
    *   Purpose: A fully managed Docker container registry.
    *   Reason for Use: Provides a secure, scalable, and reliable way to manage Docker images.

6.  **Docker:**
    *   Purpose: A platform for developing, shipping, and running applications in containers.
    *   Reason for Use: Allows for consistent and portable application deployment.

7.  **AWS Secrets Manager:**
    *   Purpose: A service to securely store, manage, and retrieve secrets.
    *   Reason for Use: Provides a secure way to manage sensitive information like API keys and database credentials.

8.  **AWS EC2 (Elastic Compute Cloud):**
    *   Purpose: Provides resizable compute capacity in the cloud.
    *   Reason for Use: Offers the flexibility and scalability needed to run the Docker containerized application.

9.  **Gunicorn:**
    *   Purpose: A Python WSGI HTTP server for UNIX.
    *   Reason for Use: Used to run the Flask application in production, providing better performance and handling more concurrent requests.

10. **Pytest:**
    *   Purpose: A framework for writing simple and scalable test cases in Python.
    *   Reason for Use: Used for unit testing the application.

11. **AWS CLI (Command Line Interface):**
    *   Purpose: A unified tool to manage AWS services from the command line.
    *   Reason for Use: Used in scripts for interacting with AWS services.

This tech stack was chosen to leverage the strengths of each component, ensuring efficient, scalable, secure, and easy-to-maintain infrastructure and application deployment.

## Datadog Agent Installation

For Datadog Agent installation, we can refer to these FAQs:

*   [https://docs.datadoghq.com/integrations/amazon_web_services/](https://docs.datadoghq.com/integrations/amazon_web_services/)
*   [https://docs.datadoghq.com/getting_started/integrations/aws/](https://docs.datadoghq.com/getting_started/integrations/aws/)
*   [https://docs.datadoghq.com/containers/docker/?tab=standard](https://docs.datadoghq.com/containers/docker/?tab=standard)

Note: While Datadog may have in-house solutions for easier Agent deployment, this project demonstrates scripting capabilities and knowledge of UNIX and Bash/Shell.

## Architecture Diagram

NOTE: When diagramming or visualizing this architecture, the Datadog Agent is usually
represented as a component sitting on each EC2 instance or within each containe. 
It acts independently to send monitoring data to Datadog’s cloud service.

```mermaid
graph LR
    User["User"] --> ELB["Elastic Load Balancer (ELB)"]
    ELB --> EC2["EC2 Instances<br>(Dockerized Flask App)"]
    EC2 --> Redshift["Amazon Redshift"]
    Datadog["Datadog Agent"] -. attached .- EC2
    EC2 --> SecretsManager["AWS Secrets Manager"]
    ECR["Amazon ECR"] --> EC2
    SecretsManager --> EC2
    style EC2 fill:yellow,stroke:black,stroke-width:2px
    style Redshift fill:red,stroke:black,stroke-width:2px
    style SecretsManager fill:black,stroke:white,stroke-width:2px
    style ECR fill:orange,stroke:black,stroke-width:2px
    style Datadog fill:purple,stroke:white,stroke-width:2px