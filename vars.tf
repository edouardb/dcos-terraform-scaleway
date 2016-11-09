variable "organization_key" {
  description = "Scaleway access_key"
  default = "00000000-0000-0000-0000-000000000000"
}

variable "secret_key" {
  description = "Scaleway secret_key"
  default = "00000000-0000-0000-0000-000000000000"
}

variable "region" {
  description = "Scaleway region: Paris (PAR1) or Amsterdam (AMS1)"
  default = "ams1"
}

variable "user" {
  description = "Username to connect the server"
  default = "root"
}

variable "dynamic_ip" {
  description = "Enable or disable server dynamic public ip"
  default = "true"
}

variable "base_image_id" {
  description = "Scaleway image ID"
  default = "00000000-0000-0000-0000-000000000000"
}

variable "scaleway_agent_type" {
  description = "Instance type of Agent"
  default = "VC1S"
}

variable "scaleway_master_type" {
  description = "Instance type of Master"
  default = "VC1S"
}

variable "scaleway_boot_type" {
  description = "Instance type of bootstrap unit"
  default = "VC1S"
}

variable "dcos_cluster_name" {
  description = "Name of your cluster. Alpha-numeric and hyphens only, please."
  default = "scaleway-dcos"
}

variable "dcos_master_count" {
  default = "3"
  description = "Number of master nodes. 1, 3, or 5."
}

variable "dcos_agent_count" {
  description = "Number of agents to deploy"
  default = "4"
}

variable "dcos_public_agent_count" {
  description = "Number of public agents to deploy"
  default = "1"
}

variable "dcos_ssh_public_key_path" {
  description = "Path to your public SSH key path"
  default = "./scw.pub"
}

variable "dcos_installer_url" {
  description = "Path to get DCOS"
  default = "https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh"
}

variable "dcos_ssh_key_path" {
  description = "Path to your private SSH key for the project"
  default = "./scw"
}
