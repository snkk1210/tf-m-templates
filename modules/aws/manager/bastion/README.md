# manager/bastion

### What is this ?

Create an EC2 for bastion.

### How to use ?

```
module "manager_bastion" {
  source = "git::https://github.com/snkk1210/tf-m-templates.git//modules/aws/manager/bastion"

  common = {
    "project"     = "snkk1210"
    "environment" = "sandbox"
  }

  vpc_id                      = <VPC_ID>
  subnet_id                   = <SUBNET_ID>
  ami                         = "ami-05ffd9ad4ddd0d6e2"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
}
```