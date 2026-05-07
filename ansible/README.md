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

## Intermediate role examples

The `intermediate` role demonstrates common Ansible patterns in separate task files:

- `tasks/loops.yml`: loops with packages and file lines
- `tasks/registers_conditions.yml`: `register`, `stat`, and `when`
- `tasks/retries_until.yml`: retry logic with `until`
- `tasks/async.yml`: asynchronous execution with polling
- `tasks/blocks.yml`: `block`, `rescue`, and `always`
- `tasks/modules.yml`: file/copy/package facts and handlers

Useful runs:

- `ansible-playbook playbooks/site.yml --tags intermediate`
- `ansible-playbook playbooks/site.yml --tags async`
- `ansible-playbook playbooks/site.yml --tags retries`
- `ansible-playbook playbooks/site.yml --extra-vars "intermediate_enable_service_example=true intermediate_service_name=ssh"`

## Advanced role examples

The `advanced` role demonstrates advanced Ansible patterns in separate task files:

- `tasks/includes_imports.yml`: static `import_tasks` and dynamic `include_tasks`
- `tasks/data_transform.yml`: `set_fact`, filters, `combine`, and deterministic hashing
- `tasks/delegation.yml`: `delegate_to`, `delegate_facts`, and `run_once`
- `tasks/strategy_serial.yml`: batch context with `ansible_play_batch` and `ansible_play_hosts_all`
- `tasks/error_handling.yml`: `block`, `rescue`, `always`, `failed_when`, `changed_when`

Useful runs:

- `ansible-playbook playbooks/site.yml --tags advanced`
- `ansible-playbook playbooks/site.yml --tags imports`
- `ansible-playbook playbooks/site.yml --tags delegation`
- `ansible-playbook playbooks/site.yml --extra-vars "advanced_serial_percent=50 advanced_max_fail_percentage=30"`
- `ansible-playbook playbooks/site.yml --extra-vars "advanced_block_required_cmd=/bin/echo"`
