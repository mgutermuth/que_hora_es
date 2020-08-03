variable "deploy_application_green" {
  description = "deploy green version"
  type        = bool
  default     = false
}

variable "version_number" {
  description = "What version to run"
  type        = string
  default     = "1"

}
variable "region" {
  description = "AWS region resources will be deployed to"
  type        = string
  default     = "us-east-2"
}

variable "cost_center" {
  description = "Tagging to say what team owns this"
  type        = string
  default     = "sandbox"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.32.0.0/16"
}

variable "public_subnet" {
  description = "CIDR for public subnet"
  type        = string
  default     = "172.32.0.0/20"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames within VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "DNS support within VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Should instances have auto-assigned public IP on launch"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "az for subnet"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}