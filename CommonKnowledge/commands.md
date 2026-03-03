# List of useful commands and best practices 🫡

### Terraform
- `terraform init`: Initialize the working directory containing Terraform configuration files.
- `terraform plan`: Create an execution plan, letting you preview the changes that Terraform plans to make to your infrastructure.
- `terraform apply`: Execute the actions proposed in a Terraform plan.
- `terraform destroy`: Destroy all remote objects managed by a particular Terraform configuration.

### Ansible
- `ansible-playbook -i inventory.ini setup.yml`: Run an Ansible playbook against the hosts defined in the inventory file.
- `ansible all -m ping -i inventory.ini`: Ping all hosts in the inventory to check connectivity.