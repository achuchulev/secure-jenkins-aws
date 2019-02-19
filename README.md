# Run Jenkins on AWS behind nginx https reverse-proxy

### Prerequisites

- git
- terraform
- own or control the registered domain name for the certificate
- have a DNS record that associates your domain name and your server’s public IP address
- AWS subscription
- ssh key

## How to build


- Get the repo

```
https://github.com/achuchulev/secure-jenkins-aws.git
cd secure-jenkins-aws
```

- Create `terraform.tfvars` file

```
access_key = "your_aws_access_key"
secret_key = "your_aws_secret_key"
ami = "your_ami_id"
instance_type = "t2.micro"
subnet_id = "subnet_id"
vpc_security_group_ids = ["security_group/s_id/s"]
public_key = "your_public_ssh_key"
cloudflare_email = "your_cloudflair_user"
cloudflare_token = "your_cloudflair_token"
cloudflare_zone = "yourdomain.com"
subdomain_name = "host01"
```

```
Note: Security group in AWS should allow ssh port 22, https port 443 and port 8443 for jenkins webhooks
```
- Initialize terraform

```
terraform init
```

- Deploy jenkins instance

```
terraform plan
terraform apply
```

- Configure Jenkins server
