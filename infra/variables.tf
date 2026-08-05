

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "secure-landing-zone-rg"
}

variable "location" {
  description = "Região Azure"
  type        = string
  default     = "francecentral"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "SecureLandingZone"
}

variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "dev"
}

variable "vnet_address_space" {
  description = "Espaço de endereços da VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "app_subnet_prefix" {
  description = "Prefixo da subnet pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "data_subnet_prefix" {
  description = "Prefixo da subnet privada"
  type        = string
  default     = "10.0.2.0/24"
}


variable "tenant_domain" {
  description = "Domain do tenant Azure (ex: sebastianascimento.onmicrosoft.com)"
  type        = string
}

variable "test_user_password" {
  description = "Password dos utilizadores de teste"
  type        = string
  sensitive   = true
}