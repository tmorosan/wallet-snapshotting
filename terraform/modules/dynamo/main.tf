resource "aws_dynamodb_table" "example-dynamodb-table" {
  name           = "${var.resource_prefix}-dynamodb-table-${var.env}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  hash_key = "Id"
  range_key = "Name"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "Name"
    type = "S"
  }
}