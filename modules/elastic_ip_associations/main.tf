variable instance_ids {
  type = list(string)
}

variable allocation_ids {
  type = list(string)
}

resource "aws_eip_association" "eip_assoc" {
  count = length(var.instance_ids)
  instance_id = var.instance_ids[count.index]
  allocation_id = var.allocation_ids[count.index]
}