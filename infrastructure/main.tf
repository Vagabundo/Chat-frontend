# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore"
    storage_account_name = "tfstorageaccvaga"
    container_name       = "tfstatefront"
    key                  = "terraform.tfstate"
  }
}

# terraform {
#   backend "remote" {
#     organization = "Vagacorp"

#     workspaces {
#       name = "web-chat-front"
#     }
#   }
# }

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "webchatfront-rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Web chat"
    Team        = "VagaDevOps"
  }
}

# resource "azurerm_app_service_plan" "freeplan" {
#   name                = "${var.resource_group_name}-plan"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   sku {
#     tier = "Free"
#     size = "F1"
#   }

#   # esto no sería necesario si mas arriba usaramos azurerm_resource_group.webchatfront-rg.name,
#   # pero lo dejo como ejemplo de uso de depends_on
#   depends_on = [azurerm_resource_group.webchatfront-rg]
# }

# resource "azurerm_container_group" "webchat_containergroup" {
#   name                = "${var.resource_group_name}-containergroup"
#   location            = azurerm_resource_group.webchatfront-rg.location
#   resource_group_name = var.resource_group_name

#   ip_address_type = "public"
#   dns_name_label  = "vagabundo-${var.project_name}"
#   os_type         = "Linux"

#   container {
#     name   = var.project_name
#     image  = "vagabundocker/${var.project_name}:${var.imagebuild}"
#     cpu    = "1"
#     memory = "1"

#     ports {
#       port     = 80
#       protocol = "TCP"
#     }
#   }

#   tags = {
#     Environment = "Web chat"
#   }
# }

resource "azurerm_app_service_plan" "linuxfreeplan" {
  name                = "${var.resource_group_name}-linuxplan"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind = "Linux"
  reserved = true

  sku {
    tier = "Free"
    size = "F1"
  }

  # esto no sería necesario si mas arriba usaramos azurerm_resource_group.webchatfront-rg.name,
  # pero lo dejo como ejemplo de uso de depends_on
  depends_on = [azurerm_resource_group.webchatfront-rg]
}

# resource "azurerm_app_service" "vagachatfront-appservice" {
#   name                = "${var.resource_group_name}-appservice"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   app_service_plan_id = azurerm_app_service_plan.linuxfreeplan.id

#   site_config {
#     linux_fx_version = "NODE|10.14"
#   }

#   tags = {
#     Environment = "Web chat"
#   }
# }