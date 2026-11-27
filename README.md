# starttech-infra

Terraform infrastructure for the StartTech DevOps assessment: VPC, EKS, S3, ECR, CloudFront, and ElastiCache Redis.

## Modules

| Module | Purpose |
|--------|---------|
| `networking` | VPC `starttech-vpc`, public/private subnets, NAT, IGW |
| `eks` | Cluster `starttech-cluster`, node group `starttech-node-group` |
| `storage` | S3 frontend bucket + ECR `starttech-backend-api` |
| `cdn` | CloudFront with `S3-Frontend` + `ALB-Backend` origins |
| `database` | ElastiCache Redis `starttech-redis` |

## Quick start

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# edit alb_dns_name after Ingress ALB exists
terraform init
terraform apply
```

Or:

```bash
./scripts/deploy-infrastructure.sh
```

## GitHub Actions

Workflow `.github/workflows/infrastructure-deploy.yml` runs on changes to `terraform/` on `main`.

Required secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, optional `ALB_DNS_NAME`.

## Grader user

Terraform creates IAM user `start-tech-grader` with the required read-only policy. Credentials:

```bash
terraform output -raw grader_access_key_id
terraform output -raw grader_secret_access_key
```
