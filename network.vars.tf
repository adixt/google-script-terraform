variable "network_allowed_ip_source_ranges" {
  default     = ["0.0.0.0/0"] # Adjust this as needed for your security requirements
  type        = list(string)
  description = "value"
}

variable "network_opened_ports_type" {
  default     = "tcp"
  type        = string
  description = "This value can either be one of the following well known protocol strings (tcp, udp, icmp, esp, ah, sctp, ipip, all), or the IP protocol number."
}

variable "network_opened_ports" {
  default     = ["30000-47000"]
  type        = list(string)
  description = "An optional list of ports to which this rule applies. Each entry must be either an integer or a range."
}

variable "network_name" {
  default     = "default"
  type        = string
  description = "name of the network"
}