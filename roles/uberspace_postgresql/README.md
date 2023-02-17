# Uberspace PostgreSQL setup Ansible role

This [Ansible role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) activates, setups and configures the [PostgreSQL](https://www.postgresql.org/) service at the German exceptional hoster [Uberspace](https://uberspace.de/). It is not officially maintained by the company. I am only one of their customers.

### Requirements / Dependencies
This role depends on my `uberspace_account` Account Setup role, which needs to be run before to provide some facts.

### Role Variables

#### Inputs
There are no variables necessary to be set explicitely in order for this role to function properly, because sane defaults are used, but some are available for fine-grained control:

* `postgres_databases` - list of databases to create. By default creates one with the name `uberspace_loginname`.
* `postgres_users` - list of users to create. Empty by default.
* Please also check [`defaults/main.yml`](defaults/main.yml) and [`vars/main.yml`](vars/main.yml).

Also there are a couple of files written and read from by default which are security relevant because they contain credentials. Make sure to only use it on encrypted filessystems and put them into your `.gitignore`.

#### Outputs/published facts
* `postgres_environment` - the shell environment used to access PostgreSQL properly. This needs to be used  as `environment: "{{ postgres_environment }}"` in any `shell`, `command` or `postgresql_*` type task in roles/playbooks consecutively depending on this.

### Example Playbook

Using an inventory `account-inventory` like this

```ini
[g_uberspace_isabell]
isabell.uber.space ansible_user=isabell  ansible_ssh_private_key_file="{{ uberspace_loginkey_path }}"
```

and a playbook `example.yml` like this

```yml
---
- name: Setup PostgreSQL on Uberspace
  hosts: g_uberspace_isabell
  gather_facts: no

  roles:
  - role: uberspace_account
    uberspace_action_setup: true
  - role: uberspace_postgres
```

you can execute `ansible-playbook -i account-inventory example.yml`. It will register a new uberspace account `isabell` (if not already there), set, setup, configure and initialize PostgreSQL and create databases and users as needed.

### License

[BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause)

### Sources

This role is largely based on the following prior work:
* https://lab.uberspace.de/guide_postgresql/
