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