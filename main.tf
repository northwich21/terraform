terraform {

   required_version = ">=0.12"

   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "3.47.0"
     }
   }
}

provider "azurerm" {
    features {}
    subscription_id = "a177ac1b-f0e1-45e5-a6c4-80266ff85e1d"
    tenant_id = "76a2ae5a-9f00-4f6b-95ed-5d33d77c4d61"
}

resource "azurerm_resource_group" "sg" {
  name     = "SG-D-Automated"
  location = "West Europe"
}