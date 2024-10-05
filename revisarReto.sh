cd
sudo yum -y install ansible-core git
rm -fr /var/log/ansible_validations.log
git clone https://github.com/nholguinrh/validacion_ansible.git
cd validacion_ansible
git pull
ansible-playbook prueba-todo.yaml
cd
cat /var/log/ansible_validations.log
