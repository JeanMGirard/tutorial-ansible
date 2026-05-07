PYTHON ?= python3
VENV ?= .venv
PIP := $(VENV)/bin/pip
ANSIBLE_GALAXY := $(VENV)/bin/ansible-galaxy
ANSIBLE_PLAYBOOK := $(VENV)/bin/ansible-playbook
MOLECULE := $(VENV)/bin/molecule

.PHONY: venv deps galaxy tf-init tf-apply tf-destroy configure molecule-test

venv:
	$(PYTHON) -m venv $(VENV)

deps: venv
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

galaxy: deps
	cd ansible && $(ANSIBLE_GALAXY) collection install -r requirements.yml

tf-init:
	cd infra && terraform init

tf-apply:
	cd infra && terraform apply -auto-approve

tf-destroy:
	cd infra && terraform destroy -auto-approve

configure:
	cd ansible && $(ANSIBLE_PLAYBOOK) -i inventory/hosts.ini playbooks/site.yml

molecule-test: galaxy
	cd ansible && $(MOLECULE) test
