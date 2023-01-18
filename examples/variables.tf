variable "list_environments" {
  description = "List of environments."
  type        = map(object({
    name   = string
    region = string
  }))
  nullable    = false
}

variable "s3_dyn_name" {
  description = "S3 bucket and DynamoDB prefix for names and other attributes."
  type        = string
}

variable "bucket_sse_algorithm" {
  type        = string
  description = "Encryption algorithm to use on the S3 bucket. Currently only AES256 is supported"
  default     = "AES256"
}

variable "region_provider" {
  type        = string
  description = "Currently mono region. Region where to deploy."
}