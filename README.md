# Uberspace Ansible collection

This [Ansible collection](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)  at the German exceptional hoster [Uberspace](https://uberspace.de/). It is not officially maintained by the company. I am only one of their customers.

Contained are some roles:

* [uberspace_account](roles/uberspace_account/) - creating/managing the uberspace account
* [uberspace_prosody](roles/uberspace_prosody/) - installing/configuring prosody

For install run `ansible-galaxy collection install friesenkiwi.uberspace` on the commandline or use a `requirements.yml` with the following content:
```yml
---
collections:
- friesenkiwi.uberspace
```
and run `ansible-galaxy collection install -r requirements.yml` afterwards.
