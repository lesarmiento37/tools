resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "SplitChecks"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "InvoiceId"
  range_key      = "UserId"

  attribute {
    name = "InvoiceId"
    type = "S"
  }

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "Checks_id"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "split-checks"
    Environment = "production"
  }
}