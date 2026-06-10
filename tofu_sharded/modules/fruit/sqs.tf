resource "aws_sqs_queue" "fruitcolor" {
  for_each = var.colors
  name     = "${var.fruit}-${each.key}"
}
