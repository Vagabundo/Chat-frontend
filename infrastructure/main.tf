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
  backend "remote" {
    organization = "Vagacorp"

    workspaces {
      name = "web-chat-front"
    }
  }
}

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

resource "azurerm_app_service_plan" "freeplan" {
  name                = "${var.resource_group_name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
//  kind = "Linux"
//  reserved = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_container_group" "webchat_containergroup" {
  name                = "${var.resource_group_name}-containergroup"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_address_type = "public"
  dns_name_label  = "vagabundo-${var.project_name}"
  os_type         = "Linux"

  container {
    name   = var.project_name
    image  = "vagabundocker/${var.project_name}:latest"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    Environment = "Web chat"
  }
}



/*resource "azurerm_app_service" "webchat-appservice" {
  name                = "${var.resource_group_name}-appservice"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.freeplan.id

  site_config {
    linux_fx_version = "DOCKER|vagabundocker/${var.project_name}:latest"
  }

  tags = {
    Environment = "Web chat"
  }
}*/