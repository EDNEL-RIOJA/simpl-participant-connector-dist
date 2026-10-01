## 1.1.1 (2025-11-26)

Switch kubectl image from Bitnami to Alpine.
Fix issue with creating secrets with empty value.
Stop overwriting Kafka users secret - allows adding custom users through OpenBao.
Fix sync issue that required deletion of init job.

## 1.1.0 (2025-11-12)

Add ServiceAccount with role and rolebinding.
Extend permissions for SecretEngine used by Infrastructure components.
Extend infrastructure-fe secret.

## 1.0.0 (2025-10-07)

Initial commit. 

