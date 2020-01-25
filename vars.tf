variable "prefix" {
  default = "Nat-Test"
}

variable "nat-startup-file" {
    type = string
    default = "nat-startup.sh"
}

provider "azurerm" {
  version = "=1.38.0"
}