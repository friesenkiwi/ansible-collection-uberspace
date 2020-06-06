# Uberspace Prosody installation Ansible role

This [Ansible role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) sets up the [Prosody](https://prosody.im/) XMPP/Jabber server at the German exceptional hoster [Uberspace](https://uberspace.de/). It is not officially maintained by the company. I am only one of their customers.

### Requirements / Dependencies
This role depends on my `uberspace` Account Setup role, which needs to be run before to provide some facts.

### Role Variables

#### Inputs
There are some variables necessary to be set in order for this role to function properly, and some more available for fine-grained control, please check [`defaults/main.yml`](defaults/main.yml) and [`vars/main.yml`](vars/main.yml). Also there are a couple of files written and read from by default which are security relevant because they contain credentials. Make sure to only use it on encrypted filessystems and put them into your `.gitignore`.

* `prosody_name` - The name of the Prosody server.
* `prosody_adminaccount` - The admin XMPP account (only local part in front of the @).
* `prosody_main_dir` - The main directory used for the source, log, pid, DH parameter, data files.
* `prosody_port_*` (`http`,`https`,`client`,`client_tls`,`server`,`proxy65`,`turn`) - The ports for the respective services. Need to be correctly updated to the opened ports after the first run.
* `prosody_turnsecret` - The secret for TURN/STUN (e.g. coturn) via the `turncredentials` module.

### Example Playbook

Using an inventory `account-inventory` like this
```ini
[g_uberspace_isabell]
isabell.uber.space ansible_user=isabell  ansible_ssh_private_key_file="{{ uberspace_loginkey_path }}"
```
and a playbook `example.yml` like this
```yml
---
- name: Setup Prosody on Uberspace
  hosts: g_uberspace_isabell
  gather_facts: no
  vars:
    uberspace_projectsdir: "{{ uberspace_spacedir + '/projekte/' }}"
    inwx_user: isabell

    uberspace_basedomain: example.com
    uberspace_servicedomain: "im"

    coturn_secret: "{{ lookup('password', 'credentials/' + 'coturn_secret') }}"

    prosody_name: IsabellJabber
    prosody_adminaccount: isabell

    prosody_main_dir: "{{ uberspace_projectsdir | realpath }}/xmpp/prosody"

    prosody_port_http: 61739
    prosody_port_https: 64654
    prosody_port_client: 43680
    prosody_port_client_tls: 43681
    prosody_port_server: 43682
    prosody_port_proxy65: 63893
    prosody_port_turn: 65000

    prosody_turnsecret: "{{ coturn_secret }}"

  roles:
  - role: uberspace_account
    uberspace_action_setup: true
  - role: uberspace_prosody

  tasks:
  - name: Run INWX domain tasks of uberspace role
    tags: dns
    import_role:
      name: uberspace
      tasks_from: inwx_domains
```

you can execute `ansible-playbook -i account-inventory example.yml`. It will register a new uberspace account `isabell` (if not already there), setup Lua, download, compile, install, configure and setup prosody, connect ports and domains, including DNS over at INWX.

### License

[BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause)

### Sources

This role is largely based on the following prior work:
* https://github.com/fapsi/lab/blob/guide_prosody/source/guide_prosody.rst
* https://plaintext.blog/hosting/Uberspace/prosody.html
* https://www.dictvm.org/de-de/prosody-auf-dem-uberspace/
* https://intux.de/2016/03/uberspace-prosody-0-9-8-0-9-10/
* https://fryboyter.de/prosody-bei-uberspace-de-installieren/
* https://pastebin.com/6ZmHsJ7U
* prosody filer : https://intux.de/2019/05/kein-bilderversand-im-gastnetzwerk/
