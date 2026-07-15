# Auto-Scaling & Self-Healing Web App on AWS (Terraform)

Infrastructure-as-code project that provisions a highlt-available, auto-scaling, self-healing web applications on AWS using terraform. EC2 Instance run behind an Auto Scaling Group spanning two Availability Zones, sclae automatically on CPU load, and are replaced automatically  if they become unhealthy.

## Achitecture

```

                --------------------------------------
                |       Auto-Scaling Group            |
                |   min=1   max=2   desired=1         |
                |   -------------   -------------     |
Internet ------>|   | EC2 (AZ-a)|   | EC2 (AZ-b)|     | <---- Launch template
                |   |   ngnix   |   |   ngnix   |     |        (ubuntu + user_data)
                |   |-----------|   |-----------|     |
                |-------------------------------------|
                                    |
                                    |
                                    \/
                        ----------------------------
                        |   Target Tracking Policy  |
                        |   (keep avg CPU = 50%)    |
                        -----------------------------

Self-Healing: If an instance becomes unhealthy or terminated, the ASG automatically launches a replacement to mainteain the desired count.
```

## What it Provisions
| File | Resources |
|------|-----------|
| `aws-vpc.tf` | VPC, **2 public subnets across 2 AZs** (via `aws_availability_zones` + `cidersubnet`), internet gateway, route table + associations |
| `aws-sg.tf` | Security Group - HTTP (80) open to all, SSH (22) restricted by CIDR |
| `aws-kp.tf` | EC2 key pair (from local public key) |
| `aws-launch-template.tf` | Ubuntu AMI data source + launch temaplate |
| `aws-asg.tf` | Auto-Scaling groups across both subnets |
| `aws-scaling.tf` | Target-tracking scaling policy (`ASGAverageCPUUtilization` @ 50%) |
| `script.sh` | user_data bootstrap - install and start ngnix |
| `provider.tf` / `terraform.tf`| AWS provider and terraform config |
| `variable.tf` / `output.tf`| Inputs and Outputs |

## Tech stack
- **Terraform** (AWS provider)
- **AWS**: VPC, AutoScaling, EC2, SG, AZ, Cloudwatch, Launch Template
- Stays within **AWS free tier**

## Prerequisites
- AWS account (Free Tier) with credentials configured via `aws configure`
- Terraform installed
- An SSH key pair — generate one in the project dir:
  ssh-keygen -t rsa -b 4096 -f id_rsa
(The public key `id_rsa.pub` is read by Terraform; keys are gitignored.)

## Usage
terraform init\
terraform plan\
terraform apply     # then confirm the SNS email subscription (check spam!)\
terraform destroy   # tear down when done\

After apply, browse to `http://<instance-public-ip>` to see the ngnix page

## Testing
**Self-Healing** - manually terminate the running instance in the EC2 console; the ASG automatically launches a replacement to restore the desried count.

**Auto-Scaling** - SSH into an instance and generate CPU load:

sudo apt update && sudo apt install stress -y
stress --cpu 2 --timeout 600

Avg CPU cross the 50% target - ASG scales out to a 2nd Instance. stop the load - it scales back in

## Future enhancements
- Add an Application Load balancer in front of the ASG
- CloudWatch dashboard for fleet-level metrics
- Refactor with reusable modules with remote state (S3 + DynamoDB)

## Author
Tushar Kashyap — SRE / DevOps Engineer · linkedin.com/in/terrykashyap