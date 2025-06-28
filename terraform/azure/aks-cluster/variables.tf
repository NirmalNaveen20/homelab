variable "prefix_name" {
    type = string
}
variable "environment_name" {
  type = string
}
variable "location" {
  type = string
}
variable "subscription_id" {
  type = string
  sensitive = true
}