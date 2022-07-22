variable "public_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDyIX0QZx749JxbjSBubyf9viXO4baSMmRJaqPSvkDVzqs08I9/jzmbs/5LBFJt7bL07j3hkIPi++k2uXrYuaejUx9rr8/F3oGX4PvUDXs1bF3nO0wmRbZmfSthTbYTLRuVPCCxvkfxrCc1o6D6ycLA+uX6rSYqaPPEz8SLTshfnZm2GZWznMyMUH0trKHRLdpSBjLT6hn5s9az6vxWjj/ksaqhMwGR3uxgksbt4hZR1/gIrhCQpS1P1k384r0V0MmTkwcnKLFZW6B1KnrbuYe4K9cetEHKz3OUKyUidXGc2eMqCYSNAbAAKKGbfgx5oXO8FIq2DnHxkPx0dVxZZ1s92ySAOjBwSo/I9OgkfukXBNYsN+RGAeHPJGeL6AYoNMof46PBxdMyM7k4+VgO+0xoKkmT2ekg16EP9CQ1rkq8zEw+POu/oOrNSFJx5t9pvbsgI3B2zqHbpPMhEKBfp4t3HOydPQFzC/KCHBucuO/dYtHw+pFvhNRC1sEI5eGqKE= anjaliagrawal@Anjalis-Air-2"
}

variable "key_name" {
  type = string
  default = "ssh-key"
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = var.public_key
}

output key_name {
  value = aws_key_pair.ssh-key.key_name
}