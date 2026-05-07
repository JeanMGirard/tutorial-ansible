# upload_files role

This role demonstrates how to use Ansible templates to create files on remote hosts.

## What it does

- Ensures destination directories exist.
- Renders one or more Jinja2 templates from `templates/`.
- Applies owner/group/mode on each rendered file.

## Variables

`upload_files_items` (list):

```yaml
upload_files_items:
  - src: tutorial_app.conf.j2
    dest: /etc/tutorial-app/tutorial_app.conf
    owner: root
    group: root
    mode: "0644"
    vars:
      app_name: tutorial-app
      app_env: tutorial
      app_port: 8080
```

## Example

The role ships with two template examples:

- `tutorial_app.conf.j2`
- `motd.j2`
