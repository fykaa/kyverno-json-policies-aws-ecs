# Specifying Region for the running instance

variable "aws_region" {
  description = "Configuring AWS as provider"
  type        = string
  default     = "us-west-1"
}

## Keys to the castle variable (AWS access and secret keys)

#variable "aws_access_key" {
#  type      = string
#  sensitive = true
#}

#variable "aws_secret_key" {
#  type      = string
#  sensitive = true
#}

# Specifying the CIDR block for the main Virtual Private Cloud (VPC).

variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

# Specifying Availability zones

variable "availability_zones" {
  type    = string
  default = "us-west-1a"
}
