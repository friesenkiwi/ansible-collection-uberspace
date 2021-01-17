# Uberspace babybuddy setup Ansible role

This [Ansible role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) sets up the [babybuddy](https://github.com/babybuddy/babybuddy) software at the German exceptional hoster [Uberspace](https://uberspace.de/). It is not officially maintained by the company. I am only one of their customers. It is largely based on the guide https://lab.uberspace.de/guide_babybuddy.html.

### Requirements / Dependencies
This role depends on my `uberspace_account` Setup role, which needs to be run before to provide some facts.
