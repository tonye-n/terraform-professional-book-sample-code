locals {
  # read all csv filenames
  files = fileset("${path.module}/files", "*.csv")

  # count the number of rows in each file
  rows = [for file in local.files : length(
    split("\n", file("${path.module}/files/${file}"))
  )]

  # sum all the row numbers
  sum = sum(local.rows)
}

output "files" {
  description = "The list of files"
  value       = local.files
}

output "rows" {
  description = "The number of rows in each file"
  value       = local.rows
}

output "sum" {
  description = "The sum of all the number of rows"
  value       = local.sum
}
