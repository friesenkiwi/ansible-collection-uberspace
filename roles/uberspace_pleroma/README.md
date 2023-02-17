# Uberspace Pleroma setup Ansible role

This [Ansible role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) sets up the [Pleroma](https://pleroma.social/) Fediverse/Mastodon server at the German exceptional hoster [Uberspace](https://uberspace.de/). It is not officially maintained by the company. I am only one of their customers. It is largely based on the guide https://github.com/fapsi/lab/blob/guide_pleroma/source/guide_pleroma.rst with some additions and tweaks.

### Requirements / Dependencies
This role depends on my `uberspace_account` Account Setup role, which needs to be run before to provide some facts.

### Features
With a minimal variable environment, the server will be set up with sane defaults, in a way that the first user and admin on the new instance will have a fediverse handle of user@user.uber.space. Not a lot of things really *need* to be provided, but some can and alter the behaviour. One particular setting is to use a different domain name for Pleroma itself and the users it serves: While the instance might be reachable at social.example.com, the users still can use handles like user@example.com. This makes use of WebFinger and is documented at https://docs-develop.pleroma.social/backend/configuration/how_to_serve_another_domain_for_webfinger/. It's implemented by just adding a simple redirect to Pleroma's `.well-known/host-meta` into the "master" server's `.htaccess`. If there are other circumstances, the playbook probably needs to be adjusted.

### Role Variables

#### Inputs
There are some variables necessary to be set in order for this role to function properly, and some more available for fine-grained control, please check [`defaults/main.yml`](defaults/main.yml) and [`vars/main.yml`](vars/main.yml). Also there are a couple of files written and read from by default which are security relevant because they contain credentials. Make sure to only use it on encrypted filessystems and put them into your `.gitignore`.

* `pleroma_instancename` - The name of the Pleroma server, default "Pleroma"
* `pleroma_host` - Hostname of the Pleroma server, default `{{ uberspace_servicedomain }}.{{ uberspace_basedomain }}`
* `pleroma_adminmail` - Admin mail address of the Pleroma server, default `{{ uberspace_mail }}`
* `pleroma_remote_post_retention_days` - Retention period for stored remote posts, after which they are cleaned up by the vaccuum process, default 60
* `pleroma_mix_environment` - Pleroma execution mode, can be "dev", default "prod"
* `pleroma_version` - Github Git repository reference, can be develop, default "stable"
* `pleroma_users` - List of Pleroma users to create, the default admin is name `{{ uberspace_loginname }}` email `{{ pleroma_adminmail }}`
* `pleroma_handle_host` - The instance's domain name that together with the user's nickname is used to construct the handle, default `{{ pleroma_host }}`
* `uberspace_masterspace_inventoryname` - Another uberspace's inventory name, which hosts the `{{ pleroma_handle_host }}`'s' domain
* `uberspace_masterspace_loginname` - The login name of that other uberspace.

### Example Playbook

Using an inventory `account-inventory` like this

```ini
[g_uberspace_isabell]
isabell.uber.space ansible_user=isabell  ansible_ssh_private_key_file="{{ uberspace_loginkey_path }}"
```

and a playbook `example.yml` like this

```yml
---
- name: Setup Pleroma Fediverse/Mastodon server on Uberspace
  hosts: g_uberspace_isabell
  gather_facts: no
  vars:
    uberspace_basedomain: example.com
    uberspace_servicedomain: "social"

  roles:
  - role: uberspace_account
    tags: account
    vars:
      uberspace_action_setup: true

  tasks:
  - name: Run uberspace pleroma role
    tags: pleroma
    import_role:
      name: uberspace_pleroma

  - name: Run web backend tasks of uberspace role
    tags: backends
    import_role:
      name: uberspace_account
      tasks_from: webbackends
  - name: Run INWX domain tasks of uberspace role
    tags: dns
    import_role:
      name: uberspace_account
      tasks_from: inwx_domains
```

you can execute `ansible-playbook -i account-inventory example.yml`. It will register a new uberspace account `isabell` (if not already there), setup PostgreSQL, download, compile, install, configure and setup Pleroma, connect webbackend and domain, including DNS over at INWX.

### License

[BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause)

### Sources

This role is largely based on the following prior work:
* https://github.com/fapsi/lab/blob/guide_pleroma/source/guide_pleroma.rst
* https://lab.uberspace.de/guide_pleroma/
