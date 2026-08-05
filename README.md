# Azure Secure Landing Zone

Infraestrutura Azure enterprise-grade com rede privada, Private Endpoints, 
Policy as Code e gestão de identidades — construída com Terraform.


###  Networking
| Recurso | Função |
|---|---|
| Virtual Network | Rede privada isolada (10.0.0.0/16) |
| app-subnet | Subnet pública — só HTTPS (443) e HTTP (80) |
| data-subnet | Subnet privada — sem acesso internet |
| NSG app-subnet | Bloqueia tudo exceto HTTPS/HTTP |
| NSG data-subnet | Só aceita tráfego da app-subnet |

###  Private Endpoints
| Recurso | Função |
|---|---|
| Storage Account | IP privado via Private Endpoint — sem acesso público |
| Key Vault | IP privado via Private Endpoint — sem acesso público |
| Private DNS Zones | Resolve nomes para IPs privados dentro da VNet |

###  Azure Policy
| Política | Função |
|---|---|
| Deny Public Storage | Bloqueia Storage Accounts públicos automaticamente |
| Require Project Tag | Todos os recursos precisam da tag Project |
| Allowed Locations | Recursos só em regiões aprovadas |

###  Identidade e Acesso (Entra ID + RBAC)
| Recurso | Função |
|---|---|
| Grupo Developers | Acesso Reader ao Resource Group |
| Grupo SecurityAdmins | Acesso Security Reader + Key Vault Secrets User |
| Managed Identity | Acede ao Key Vault e Storage sem credenciais hardcoded |


## Princípios de segurança aplicados

| Princípio | Como está implementado |
|---|---|
| Least Privilege | RBAC com roles mínimas por grupo |
| Zero Trust | Conditional Access + MFA fora de Portugal |
| Defense in Depth | VNet + NSGs + Private Endpoints + Policy |
| No Credentials | Managed Identity em vez de passwords |

## Como usar

```bash
cd infra
terraform init
terraform plan
terraform apply
```

## Stack técnica

Terraform · Azure VNet · NSG · Private Endpoints · Azure Policy · 
Microsoft Entra ID · RBAC · Managed Identity