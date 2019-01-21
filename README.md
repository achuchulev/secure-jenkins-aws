# A sample repo with example of running Jenkins on AWS behind nginx https reverse-proxy

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
https://github.com/achuchulev/secure-nomad-https.git
cd secure-nomad-https
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
```

```
Note: Security group in AWS should allow ssh on port 22 and https on port 443, also 8443 for jenkins webhooks
```

- Edit script scripts/provision.sh and set below variables under section Generate certificate

```
EMAIL=you@example.com
DOMAIN_NAME=your.dns.name
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
