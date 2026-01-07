


all:
	ansible-playbook ./playbooks/playbook.yaml

clean:
	ansible-playbook ./playbooks/reset.yaml

dump:
	ansible-playbook ./playbooks/playbook.yaml --start-at-task="Copy dump"

config:
	ansible-playbook ./playbooks/playbook.yaml --start-at-task="Generate .env from template"

serv1:
	ansible-playbook ./playbooks/serv1.yaml

serv2:
	ansible-playbook ./playbooks/serv2.yaml

re:	all

connect1:
	ssh root@51.159.150.9
connect2:
	ssh root@24.199.120.225

