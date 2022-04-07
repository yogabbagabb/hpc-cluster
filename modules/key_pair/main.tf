variable "public_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIpaMO3Mw+SVYGIsHXCCZBr/vT8k3b42At6dQQBlu1891xDG1D+npUF8jrAG9mSLuIRP9lVn4tJ1Ih0cpzeeJlNIWWesjycFhYkrtkmXsxwPVCJwT0mfYJO/aLCVjCdkgofMo9MfrOrIiH1oZoj1C09sTIkkl5USC5lujfsSMgJ4WocrgqRKr4kPY/gYBEVpSh+brInz7wcXwe4zkfvdMKUlz4SPZaUz5M+qWJCg4aqM2RgFDR+qctaVjqd2SRPsYlQ71XDkzdyzidKvJ5yZLdkx8bMtJCynV1e6odMB1G6CxANjoirayJ7x0B0uG8Mi0LHl/XN8fZvErtst2BprsasF/59qeOkNll2r8kxdPpJpHnrw3wDdksJKzgE/hqVY+K2N6pf66nTBsT9kQvRS53/msEX92k/O+z2UZmEdGRqscc1Pfqcq97urQfeoFigEv5Zn/y8XoBIhcKgOc0HikE2cMFMC4wl0L+f60sMG/YPUY4iINyqg9n8awvdcbZG1U= anjaliagrawal@Anjalis-Air-2"
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