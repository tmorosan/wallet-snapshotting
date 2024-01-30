output "bucket" {
  value = aws_s3_bucket.state_bucket.id
}

output "state_lock" {
  value = aws_dynamodb_table.state_lock.id
}