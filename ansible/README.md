# Ansible

## Basics

1. Install requirements.yml with `ansible-galaxy install -r requirements.yml`
2. Run `ansible-playbook playbooks/site.yml --verbose`
3. Run `ansible-playbook playbooks/site.yml --tags update`
4. Run `ansible-playbook playbooks/site.yml --limit <host>`
5. Run `ansible-playbook playbooks/site.yml --check` to simulate changes without applying them
6. Run `ansible-playbook playbooks/site.yml --syntax-check` to check playbook syntax without running it 
7. Run `ansible-playbook playbooks/site.yml --inventory <file>` to specify inventory file 
8. Run `ansible-playbook playbooks/site.yml --list-tasks` to list tasks in the playbook 
9. Run `ansible-playbook playbooks/site.yml --list-hosts` to list hosts targeted by the playbook
10. Run `ansible-playbook playbooks/site.yml --extra-vars "key=value"` to pass extra variables to playbook
11. Run `ansible-inventory -i inventory/hosts.yml --graph` to visualize inventory structure

## 



