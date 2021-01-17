# Uberspace Ansible collection

This [Ansible collection](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) provides means for operating at the German exceptional hoster [Uberspace](https://uberspace.de/). It is not officially maintained by the company. I am only one of their customers.

Contained are some roles:

* [uberspace_account](roles/uberspace_account/) - Creating/managing the Uberspace account itself and additionally [INWX](https://www.inwx.de/de/) domains
* [uberspace_coturn](roles/uberspace_coturn) - Installing/configuring the [coturn](https://github.com/coturn/coturn#readme) TURN/STUN server
* [uberspace_prosody](roles/uberspace_prosody/) - Installing/configuring [Prosody](https://prosody.im/) Jabber/XMPP server ([`A` security assessment](https://www.xmpp.net/) and ready for [full compliance and compatibility](https://compliance.conversations.im/tests/) with [Conversations](https://conversations.im/), including file sharing via proxy and upload through external [prosody-filer](https://github.com/ThomasLeister/prosody-filer), [OMEMO](https://conversations.im/omemo/), proxy65, MUC, coturn/calling, user creation, DNS records, MySQL storage backend, BOSH+discovery, invitation )
* WIP: [uberspace_mongodb](roles/uberspace_mongodb/) - Installing/configuring [MongoDB](https://www.mongodb.com/) based on [https://lab.uberspace.de/guide_mongodb.html]
* WIP: [uberspace_wekan](roles/uberspace_wekan/) - Installing/configuring  [Wekan](https://wekan.github.io/) based on [https://github.com/wekan/wekan/wiki/Install-latest-Wekan-release-on-Uberspace]
* WIP: [uberspace_pleroma](roles/uberspace_pleroma/) - Installing/configuring [Pleroma](https://pleroma.social/)

Coming up next:
* [Web headers](https://manual.uberspace.de/web-headers.html#headers)
* [Node.js](https://manual.uberspace.de/lang-nodejs.html)
* [PostgreSQL](https://www.postgresql.org/) based on [https://lab.uberspace.de/guide_postgresql.html]

For install run `ansible-galaxy collection install friesenkiwi.uberspace` on the commandline or use a `requirements.yml` with the following content:
```yml
---
collections:
- friesenkiwi.uberspace
```
and run `ansible-galaxy collection install -r requirements.yml` afterwards.

## Related works

There are some other projects, approaching "Ansible @ Uberspace" from a slightly different angle:
* https://github.com/Snapstromegon/ansible-roles-uberspace
* https://github.com/yeah/ansible-uberspace
* https://github.com/golderweb/ansible-dotqmail
