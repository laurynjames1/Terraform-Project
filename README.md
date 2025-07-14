# Azure Infrastructure Deployment with Terraform

##  Overview

This Terraform project provisions a secure, Linux-based virtual infrastructure on Microsoft Azure. It includes the following resources:

- **Resource Group**
- **Virtual Network & Subnet**
- **Network Security Group (NSG) and inbound SSH rule**
- **Network Interface**
- **Linux Virtual Machine (Ubuntu 22.04 LTS)**
- **Storage Account for boot diagnostics**
- **Azure Log Analytics Workspace**
- **Azure Sentinel onboarding**
- **AMA extension for monitoring (installed via Azure GUI)**

This deployment is intended for development, testing, or demonstration purposes and should be customized for production environments.

---

##  Resources Deployed

| Resource                          | Description                                    |
|:--------------------------------- |:----------------------------------------------|
| `azurerm_resource_group`         | Resource group to organize deployed resources |
| `azurerm_virtual_network`        | Private virtual network                       |
| `azurerm_subnet`                 | Subnet within the virtual network             |
| `azurerm_network_security_group` | NSG with a rule allowing SSH from a trusted IP|
| `azurerm_network_interface`      | Network interface attached to VM             |
| `azurerm_linux_virtual_machine`  | Ubuntu-based VM with SSH key authentication   |
| `azurerm_storage_account`        | Storage account for boot diagnostics          |
| `azurerm_log_analytics_workspace`| Log Analytics Workspace for Azure Sentinel    |
| `azurerm_sentinel_log_analytics_workspace_onboarding` | Onboards Log Analytics to Azure Sentinel |


---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= v1.5.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure Subscription and Service Principal credentials

---

## 📂 Project Structure
- main.tf # Main Terraform configuration
- variables.tf # Input variables definition
- terraform.tfvars.example # Example variable values (DO NOT COMMIT real values)
- README.md # This file

---

## Notes
- The VM uses SSH key authentication only
- Storage account names must be globally unique — this is handled by appending a random string
- Sentinel is connected to the Log Analytics workspace and the AMA agent is configured for monitoring
- Make sure the workspace_key is securely managed and never hardcoded into source control

---

## Security Best Practices
- Use remote state with Azure Storage or Terraform Cloud
- Rotate SSH keys and workspace keys periodically
- Restrict NSG rules to trusted IP addresses only
- Avoid hardcoding any sensitive values into .tf files

---

## License
MIT License. See LICENSE for details.

---

## Acknowledgments
Built as part of a personal Azure cybersecurity infrastructure project by Lauryn James.

---

**Happy building and secure cloud engineering!**
