# Python-AI-AWS-Docker

For educational purposes, want to perform a AWS EC2 deployment for a Python AI WebApp, using AWS RDS as DB, and AWS Elastic Load Balancing as a requirement for our app. (going all AWS here)

We will say that we want to deploy our app via Docker, and two environments are required, prod and dev (for obvious reasons).

For security, use AMI and IAM by AWS and Vault for sensitive data management and AWS SecretManager for keeping ALL sensitive data. Ensure that security is the highest priority.

For observability, use Datadog and for now, we will just look at the APM and we will decide on the next steps.

Stack choice:

1. Flask:
● Purpose: Flask is a micro web framework for Python.
● Reason for Use: It's lightweight, easy to set up, and well-suited for building small to medium-sized APIs and web applications. It allows for quick development and flexible integration with other components.

2. NLTK (VADER):
● Purpose: NLTK's VADER is used for sentiment analysis of text data.
● Reason for Use: VADER is a lexicon and rule-based sentiment analysis
tool specifically attuned to sentiments expressed in social media. It is easy
to use, requires no training data, and is effective for the project's sentiment analysis needs.

3. Psycopg2:
● Purpose: A PostgreSQL adapter for Python, used for database
interactions.
● Reason for Use: Psycopg2 is the most popular PostgreSQL database
adapter for Python, offering robust features and efficient interaction with PostgreSQL databases like Amazon Redshift.

4. Amazon Redshift:
● Purpose: A fully managed, petabyte-scale data warehouse service in the
cloud.
● Reason for Use: Redshift is optimized for data analysis and can handle
large volumes of data efficiently, making it suitable for storing and querying sentiment analysis results.

5. Amazon ECR (Elastic Container Registry):
● Purpose: A fully-managed Docker container registry that makes it easy to
store, manage, and deploy Docker container images.
● Reason for Use: ECR provides a secure, scalable, and reliable way to
manage Docker images, integrating seamlessly with AWS services for deployment.

6. Docker:
● Purpose: A platform for developing, shipping, and running applications in containers.
● Reason for Use: Docker allows for consistent and portable application
deployment, encapsulating the application and its dependencies in a
single container that can run on any system that supports Docker.

7. AWS Secrets Manager:
● Purpose: A service to securely store, manage, and retrieve secrets.
● Reason for Use: Secrets Manager provides a secure way to manage
sensitive information like API keys and database credentials, reducing the
risk of exposure.

8. AWS EC2 (Elastic Compute Cloud):
● Purpose: A web service that provides resizable compute capacity in the
cloud.
● Reason for Use: EC2 offers the flexibility and scalability needed to run the Docker containerized application, with the ability to scale resources as needed.

9. Gunicorn:
● Purpose: A Python WSGI HTTP server for UNIX.
● Reason for Use: Gunicorn is used to run the Flask application in
production, providing better performance and handling more concurrent
requests than Flask's built-in server.

10. Pytest:
● Purpose: A framework for writing simple and scalable test cases in
Python.
● Reason for Use: Pytest is used for unit testing the application, ensuring code quality and reliability through automated tests.

11. AWS CLI (Command Line Interface):
● Purpose: A unified tool to manage AWS services from the command line.
● Reason for Use: The AWS CLI is used in scripts for interacting with AWS
services like ECR and Secrets Manager, automating tasks such as image
retrieval and secret access.
This tech stack was chosen to leverage the strengths of each component, ensuring efficient, scalable, secure, and easy-to-maintain infrastructure and application deployment.

As for the Datadog Agent install, we can follow or be inspired from these FAQs:
● https://docs.datadoghq.com/integrations/amazon_web_services/
● https://docs.datadoghq.com/getting_started/integrations/aws/
● https://docs.datadoghq.com/containers/docker/?tab=standard

Note: While Datadog may have in-house solutions to help us deploy the Agent easily, we want to demonstrate our scripting capabilities and knowledge of UNIX and Bash/Shell for the purpose of this project.

Below is a conceptual description of how you might represent this architecture
diagrammatically:

+-------+     +-----+     +---------------------------------+
| User  | --> | ELB | --> | EC2 Instances (Dockerized Flask App) |
+-------+     +-----+     +---------------------------------+
                  ^        |
                  |        +-----------------+     +-----------------+
                  |------->| Datadog Agent   |----->| Amazon Redshift |
                  |        +-----------------+     +-----------------+
                  |        |                 ^
                  |        |                 |
                  |        |                 |
                  |        +-----------------+     +-----------------------+
                  |------->| Amazon ECR      |----->| AWS Secrets Manager    |
                           +-----------------+     +-----------------------+

```mermaid
graph LR
    User["User"] --> ELB["Elastic Load Balancer (ELB)"]
    ELB --> EC2["EC2 Instances<br>(Dockerized Flask App)"]
    EC2 --> Redshift["Amazon Redshift"]
    EC2 --> Datadog["Datadog Agent"]
    EC2 --> SecretsManager["AWS Secrets Manager"]
    ECR["Amazon ECR"] --> EC2
    Datadog --> Redshift
    SecretsManager --> EC2
    style EC2 fill:#ccf,stroke:#888,stroke-width:2px
    style Redshift fill:#fcc,stroke:#888,stroke-width:2px
    style SecretsManager fill:#cfc,stroke:#888,stroke-width:2px
    style ECR fill:#cff,stroke:#888,stroke-width:2px

NOTE: When diagramming or visualizing this architecture, the Datadog Agent is usually
represented as a component sitting on each EC2 instance or within each container, rather than
between the ELB and instances. It acts independently to send monitoring data to Datadog’s
cloud service.