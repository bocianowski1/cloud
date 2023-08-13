variable "location" {
  type        = string
  description = "Azure region to deploy resources to"
}

variable "prefix" {
  type        = string
  description = "Prefix to use for all resources"
}

variable "news_api_key" {
  type        = string
  description = "The API key for the News API"
}