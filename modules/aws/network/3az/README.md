## network/3az

### What is this ?

Create a 3az 3-tier ( 2-tier ) VPC network.

### How to use ?

```
module "network_3az" {
  source = "git::https://github.com/snkk1210/tf-m-templates.git//modules/aws/network/3az"

  common = {
    "project"     = "snkk1210"
    "environment" = "sandbox"
  }

  vpc_cidr = "10.0.0.0/16"

  az1 = "ap-northeast-1a"
  az2 = "ap-northeast-1c"
  az3 = "ap-northeast-1d"

  public_az1_cidr = "10.0.0.0/20"
  public_az2_cidr = "10.0.16.0/20"
  public_az3_cidr = "10.0.32.0/20"

  enable_private   = true
  private_az1_cidr = "10.0.48.0/20"
  private_az2_cidr = "10.0.64.0/20"
  private_az3_cidr = "10.0.80.0/20"

  isolated_az1_cidr = "10.0.96.0/20"
  isolated_az2_cidr = "10.0.112.0/20"
  isolated_az3_cidr = "10.0.128.0/20"
}
```