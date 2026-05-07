# Advanced role examples

This role demonstrates more advanced Ansible syntax and execution patterns.

## Included task categories

- `tasks/includes_imports.yml`: `import_tasks` vs `include_tasks`
- `tasks/data_transform.yml`: Jinja filters, `set_fact`, `combine`, hashing, payload rendering
- `tasks/delegation.yml`: `delegate_to`, `delegate_facts`, `run_once`
- `tasks/strategy_serial.yml`: serial batch metadata with `ansible_play_batch`
- `tasks/error_handling.yml`: `block`/`rescue`/`always`, `failed_when`, `changed_when`

## Useful runs

- `ansible-playbook playbooks/site.yml --tags advanced`
- `ansible-playbook playbooks/site.yml --tags delegation`
- `ansible-playbook playbooks/site.yml --extra-vars "advanced_block_required_cmd=/bin/echo"`
- `ansible-playbook playbooks/site.yml --extra-vars "advanced_serial_percent=50 advanced_max_fail_percentage=30"`
