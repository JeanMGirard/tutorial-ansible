# tutorial-ansible

Hands-on tutorial project that uses Terraform to provision a small EC2 instance and Ansible to configure it. The repository also includes Molecule tests for the Ansible role.

## Project layout

- `infra/`: Terraform code to create key pair, security group, and EC2 instance
- `ansible/`: Ansible inventory, playbook, role, and Molecule tests
- `requirements.txt`: Python tooling dependencies (Ansible, Molecule, linting)
- `Makefile`: Optional shortcuts for common commands

## Prerequisites

- Python 3.10+
- Terraform 1.6+
- AWS account and credentials configured for your shell (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` or profile)
- Docker (for Molecule local tests)

## 1) Install local dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

Install Ansible collections used by this project:

```bash
cd ansible
ansible-galaxy collection install -r requirements.yml
cd ..
```

## 2) Provision EC2 with Terraform

```bash
cd infra
terraform init
terraform apply
cd ..
```

What this does:

- Generates an SSH key at `infra/.generated/ansible-ec2.pem`
- Creates a key pair in AWS from the generated key
- Creates a security group with SSH access (`22/tcp`)
- Creates one EC2 instance (`t3.micro` by default)
- Writes inventory to `ansible/inventory/hosts.ini`

## 3) Configure the EC2 instance with Ansible

```bash
cd ansible
ansible-playbook -i inventory/hosts.ini playbooks/site.yml
cd ..
```

The `common` role currently:

- Updates apt cache
- Upgrades installed packages
- Installs baseline tools (`curl`, `git`, `htop`, `vim`)

## 4) Run Molecule tests

Molecule validates role behavior in a disposable Docker container before you run it in AWS.

```bash
cd ansible
molecule test
cd ..
```

## Optional: Makefile shortcuts

```bash
make deps
make galaxy
make tf-init
make tf-apply
make configure
make molecule-test
```

## Cleanup

Destroy cloud resources when done:

```bash
cd infra
terraform destroy
cd ..
```

## Notes

- Default SSH ingress is open to `0.0.0.0/0` for tutorial simplicity. Restrict `allowed_ssh_cidrs` in `infra/variables.tf` for real use.
- Terraform will overwrite `ansible/inventory/hosts.ini` on each `terraform apply`.
- The repository ignores generated key and Terraform state-related files via `.gitignore`.
