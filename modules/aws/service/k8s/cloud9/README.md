# service/k8s/cloud9

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloud9_environment_ec2.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_ec2) | resource |
| [aws_iam_instance_profile.cloud9_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.cloud9_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aws_cloud9_ssm_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [null_resource.associate_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_iam_policy_document.cloud9_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common"></a> [common](#input\_common) | n/a | <pre>object({<br>    project      = string<br>    environment  = string<br>    region = string<br>  })</pre> | <pre>{<br>  "environment": "",<br>  "project": "",<br>  "region": ""<br>}</pre> | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | n/a | `string` | `"amazonlinux-2-x86_64"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t3.micro"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud9_instance_id"></a> [cloud9\_instance\_id](#output\_cloud9\_instance\_id) | n/a |
| <a name="output_cloud9_url"></a> [cloud9\_url](#output\_cloud9\_url) | n/a |

## After applying

- Install kubectl ( ap-northeast-1 )
```
rm -vf ${HOME}/.aws/credentials
AWS_REGION="ap-northeast-1"
aws configure set region ${AWS_REGION}
export AWS_PAGER=""
cat <<"EOT" >> ${HOME}/.bashrc
export AWS_PAGER=""
EOT
sudo curl -L -o /usr/local/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.1/2023-09-14/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl
```

- Create context ( ap-northeast-1 )
```
aws eks --region ap-northeast-1 update-kubeconfig --name ${eks-cluster-name}
```

- Modify ConfigMap ( ap-northeast-1 )
```
eksctl create iamidentitymapping --cluster {eks-cluster-name} --region=ap-northeast-1 \
    --arn arn:aws:iam::${aws-account-id}:role/${role-name} --username admin --group system:masters \
    --no-duplicate-arns
```

