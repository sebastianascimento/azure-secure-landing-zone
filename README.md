# Azure Secure Landing Zone

Infraestrutura Azure enterprise-grade com rede privada,
Private Endpoints e Policy as Code — construída com Terraform.

## O que provisiona

| Recurso | Função |
|---|---|
| Virtual Network | Rede privada isolada |
| app-subnet | Subnet pública — só HTTPS |
| data-subnet | Subnet privada — sem acesso internet |
| NSGs | Regras de tráfego por subnet |
| Storage Account | IP privado via Private Endpoint |
| Key Vault | IP privado via Private Endpoint |
| Azure Policy | Bloqueia recursos públicos automaticamente |

## Como usar

```bash
cd infra
terraform init
terraform plan
terraform apply
```

## Stack
Terraform · Azure VNet · NSG · Private Endpoints · Azure Policy
EOF