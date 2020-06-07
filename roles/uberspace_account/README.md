# Uberspace Administration Ansible role

This [Ansible role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) helps with the administration of accounts at the German exceptional intenet hoster [Uberspace](https://uberspace.de/). It is not officially maintained by the company. I am only one of their customers. It is acting through the user frontend via HTTPS and content parsing, but since there is no official API, things can break easily as soon as Uberspace changes anything in the frontend, specifically does a frontend relaunch etc.

When using this role, make sure that you understand, respect and cherish the [philosophy](https://wiki.uberspace.de/philosophy) and share the values of Uberspace. Specifically: Don't abuse the provided priviledges and don't overburden the technical infrastructure!

By using this role, anybody can set up a desired application in a matter of minutes. But beware, you should be aware of what is happening in the back, since you will be responsible for it and the impact it has on it's users. That includes updates, privacy and other security aspects. So read through the [`tasks/*.yml`](tasks/) files to understand it's magic!

This role is tailored to run from a Linux controller only for Uberspace v7, not v6! It can
* Register new account
* Set password
* Deploy SSH login authorized key, generate in advance if necessary
* Delete an account
* Trust SSH host keys via local user `known_hosts` file
* Gather facts (for other roles/tasks running afterwards)
  * Opened ports
  * Registered domains
  * public/private IPv4/v6 addresses
  * Hostname and other common variables (E-Mail etc.)
* Register/open new ports
* Connect domains to the uberspace
* Set A(AAA) and SRV DNS records at the facultative/complementary separate German Domain/DNS hoster [INWX](https://www.inwx.de/de/)  (separate tasks file, use `tasks_from: inwx_domains` on the `import_role:` module)

for now. More features may be added in the future, Merge/Pull Requests are much appreciated!

### Requirements / Dependencies

For the INWX part of the role (setting the DNS records), you need to have the [`inwx.collection`](https://github.com/inwx/ansible-collection) installed, e.g. by running `ansible-galaxy collection install inwx.collection`. Also, you need to already have an account over at INWX and register a domain there, under which the records can be managed. If you don't have one, you can still use the rest of the role.

### Role Variables

There are some variables necessary to be set in order for this role to function properly, and some more available to control it's behaviour. Also there are some facts gathered which can be used in tasks/role executions afterwards, e.g. to install/configure applications running on the uberspace. Also there are a couple of files written and read from by default which are security relevant because they contain credentials. Make sure to only use it on encrypted filessystems and put them into your `.gitignore`.

#### Inputs
* `uberspace_loginname` - by default `{{ ansible_user }}` from the inventory
* `uberspace_loginpassword` - by default read from `credentials/uberspace_loginpassword_{{ uberspace_loginname }}`
* `uberspace_loginkey` - by default read from `~/.ssh/id_uberspace_{{ uberspace_loginname }}`
* `uberspace_action_setup` - whether to register a new account, set the password or deploy the loginkey - by default `false`
* `uberspace_action_delete` - whether to delete an account - by default `false`
* `uberspace_ports_goal` - list of ports used by running services. Since Uberspace can only open ports on an availability base, users cannot request a *specific* port to be opened. Rather, the length of this list is compared to the actual open ports and the missing number of ports requested. This variable should afterwards be adjusted manually in the code accordingly.
* `uberspace_domains_goal` - list of domains to be registered to the uberspace via `uberspace web domain add`
* `uberspace_basedomain` - base domain for services, e.g. `example.com`
* `uberspace_servicedomain` - subdomain under which services should be available, e.g. `foo.bar` would result in `foo.bar.example.com`
* `inwx_user` - username at INWX
* `inwx_pw` - password at INWX, by default read from `credentials/inwx-{{ inwx_user }}-pw`
* `inwx_records_a` - list of domains for A and AAAA records
* `inwx_records_srv` - dictionary of domains, services and ports for SRV records. The expected structure is like this (`xmpp-client`/`xmpp-server` are the service names and need to be adjusted for your case, as you can see, the `inwx_records_a` list can be reused):
  ```yml
  inwx_records_srv:
    xmpp-client:
      port: "{{ prosody_port_client }}"
      domains: ['']
    xmpp-server:
      port: "{{ prosody_port_server }}"
      domains: "{{ inwx_records_a }}"
  ```
  The above would result in the following DNS resource records:
  ```
  _xmpp-client._tcp.{{ uberspace_servicedomain }}.{{ uberspace_basedomain }}.   3600 IN    SRV 10       0     {{ prosody_port_client }} {{ uberspace_servicedomain }}.{{ uberspace_basedomain }}.
  _xmpp-server._tcp.{{ inwx_records_a[0] }}.{{ uberspace_servicedomain }}.{{ uberspace_basedomain }}.   3600 IN    SRV 10       0     {{ prosody_port_client }} {{ uberspace_servicedomain }}.{{ uberspace_basedomain }}.
  [… more depending on the contents of inwx_records_a]
  ```
  e.g.
  ```
  _xmpp-server._tcp.conference.im.example.com.   3600 IN    SRV 10       0     43682 im.example.com.
  ```
There are a couple more variables available for fine-grained control, please check [`defaults/main.yml`](defaults/main.yml) and [`vars/main.yml`](vars/main.yml).

#### Outputs/published facts
* `uberspace_ip_public_v4`, `uberspace_ip_public_v6`, `uberspace_ip_private_v4`, `uberspace_ip_private_v6` - The IPv4 and IPv6 addresses of the uberspace. "Private" are the carrier-grade NAT/unique local ones (`100.64.x.y`, `fed75::xxx::2`) of the user's virtual network interface, "public" are the host's WAN ones, facing the internet (`185.26.156.x`/`2a00:d0c0:200:0:48a:86ff:fe54:xxxx`). [See also Uberspace manual](https://manual.uberspace.de/en/background-network.html#network-namespaces).
* `uberspace_host` - The fully qualified domain name of the host the uberspace is on, like `stardust.uberspace.de`.
* `uberspace_ports` - The ports currently opened in the firewall (using `uberspace port list` on the command line)
* `uberspace_domains` - The domains registered to the uberspace (using `uberspace web domain list` on the command line)

#### Files
There are a couple of files expected, read or written by this role, all in the directory `credentials/` next to the playbook `.yml` file:
* `uberspace_loginpassword_{{ uberspace_loginname }}` - Required for basic operation, place there manually. beforehand. In case of new account creation would be randomly generated if not present before.
* `uberspace_session_{{ uberspace_loginname }}` - Will automatically be written as a cache for the web session ID, will automatically be refreshed when the session expired. Using this ID in the HTTP header, you can log into the uberspace dashboard.
* `inwx-{{ inwx_user }}-pw` - Required for DNS operations, place there manually beforehand.

The names, locations or lookup methods (e.g. to switch to [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html)) can be changed by overriding the values of `defaults/main.yml`.

### Example Playbook

Using an inventory `account-inventory` like this
```ini
[g_uberspace_isabell]
isabell.uber.space ansible_user=isabell ansible_ssh_private_key_file="{{ uberspace_loginkey_path }}"
```
and a playbook `example.yml` like this
```yml
---
- name: Setup, query and delete again an Uberspace
  hosts: g_uberspace_isabell
  gather_facts: no
  vars:
    service_port: 40132
    uberspace_basedomain: example.com
    uberspace_servicedomain: foo.bar
    uberspace_ports_goal: [ "{{ service_port }}" ]
    uberspace_domains_goal: [ "{{ uberspace_servicedomain }}.{{ uberspace_basedomain }}" ]
    inwx_user: isabell
    inwx_records_a: [ "{{ uberspace_servicedomain }}" ]
    inwx_records_srv:
      service-foo:
        port: "{{ service_port }}"
        domains: "{{ inwx_records_a }}"
  roles:
  - role: uberspace_account
    uberspace_action_setup: true

  tasks:
  - name: Setup INWX domains/DNS
    import_role:
      name: uberspace_account
      tasks_from: inwx_domains
  - name: Setup application
    debug:
      msg: Do your things here

  - name: Delete uberspace
    vars:
      uberspace_action_delete: yes
    include_role:
      name: uberspace_account
```
you can execute `ansible-playbook -i account-inventory example.yml`. It will register a new account `isabell`, gather and display the facts, setup ports and domains including DNS over at INWX and afterwards delete the account again.

### License

[BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause)
