resource "aws_dynamodb_table" "tf_state_lock" {
  name = var.dynamodb_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}