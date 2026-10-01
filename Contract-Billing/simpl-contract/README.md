Prerequisites:
1. Vault
2. Postgres db
3. Kafka server
4. To connect to the vault service provider class is used and vault instance should allow that

Installation:
1. Update values under deployment.db/kafka/vault/urls
2. To deploy consumer deployment.mode should be CONSUMER, and deployment.vault.hashicorp.role should be "contract-consumer".
   To deploy provider deployment.mode should be PROVIDER, and deployment.vault.hashicorp.role should be "contract-provider".
