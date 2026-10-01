
# Infrastructure Modules (BE and FE) deployment on external kubernetes

### How to deploy the Simpl API and UI in a Kubernetes cluster (step-by-step guide)

---

## Requirements
- [Kubernetes cluster](https://kubernetes.io/docs/setup/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Postgres](https://bitnami.com/stack/postgresql/helm)
- [Kafka](https://bitnami.com/stack/kafka)
- [Vault]https://bitnami.com/stack/hashicorp-vault)

---
## Configuration
### Container images
Release images are published at `ghcr.io/cnie-es`; public packages require no personal token.

---
## Deploy

_**Remember: You need your kubeconfig.yaml file to access your cluster. Copy the commands below and update the kubeconfig path accordingly.**_

#### Before you start:
- Go to Chart.yaml file and replace ${PROJECT_RELEASE_VERSION} to a fake version (0.0.1)
- Go to values.yaml and fill all the env variables as in the example
```json
  env:
  
    POSTGRES_HOST: postgressql.be-common.svc.cluster.local
    SPRING_DATASOURCE_URL: jdbc:postgresql://postgressql.be-common.svc.cluster.local:5432/simpl_infrastructure
    SPRING_DATASOURCE_USERNAME: infrastructure_be-api
    SPRING_DATASOURCE_PASSWORD: ***************
    SPRING_JPA_HIBERNATE_DDL_AUTO: update
    SPRING_JPA_SHOW_SQL: "false"
    SPRING_JPA_DEFER_DATASOURCE_INITIALIZATION: "true"
    SPRING_SQL_INIT_MODE: always
    SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT: org.hibernate.dialect.PostgreSQLDialect
    SPRING_PROFILES_ACTIVE: docker
    SPRING_KAFKA_BOOTSTRAP_SERVERS: infrastructure-backend-kafka-svc.infrastructure.svc.cluster.local:9092
    SPRING_MAIL_HOST: "smtp.ionos.de"
    SPRING_MAIL_PORT: 587
    SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH: "true"
    SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_REQUIRED: "false"
    SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE: "true"
    SPRING_CLOUD_VAULT_TOKEN: ""
    SPRING_CLOUD_VAULT_URI: http://vault-infrastructure-internal.infrastructure.svc.cluster.local:8200
    SPRING_CLOUD_VAULT_KV_ENABLED: "true"
    SPRING_CONFIG_IMPORT: "vault://dev-engine/data/infrastructure/dev"
    SPRING_CLOUD_VAULT_KV_VERSION: "2"
    VAULT_TOKEN: 
    VAULT_URL: "http://vault-infrastructure-internal.infrastructure.svc.cluster.local:8200/v1/secret/data/users/"
    SERVER_PORT: "8081"
```

**Step 1** - Open you command line

**Step 2** - Go to charts folder

```cmd
cd charts
```

**Step 3** - Execute Helm\
Run the following command to deploy the containers:

```cmd
helm upgrade --kubeconfig yourKubeconfigPath\kubeconfig.yaml --install --create-namespace -n infrastructure . -f values.yaml
```
