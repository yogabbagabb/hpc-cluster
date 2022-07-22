
resource "aws_eip" "eip" {

}

output "eip_addresses" {
  value = aws_eip.eip.public_ip
}

output "eip_allocation_ids" {
  value = aws_eip.eip.allocation_id
}