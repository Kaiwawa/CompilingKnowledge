# List of useful commands and best practices 🫡

## WSL
- wsl --install [Distro] --name Ubuntu-Ansible


## Terraform
- docker run -it -v .:/app -w /app --entrypoint "" hashicorp/terraform:light sh
- export AWS_ACCESS_KEY_ID=
- export AWS_SECRET_ACCESS_KEY=


## Ansible
- apt update
- apt upgrade -y
- apt install software-properties-common -y
- add-apt-repository --yes --update ppa:ansible/ansible
- apt install ansible -y


## Linux
### Create a SSH-Key and add the .pub to ~/.ssh/authorized_key \
### So you can login without password
- ssh-keygen -t rsa -b 4096 -m PEM -f permission.pem

### To connect without -i on ssh
- ssh-agent bash && ssh-add [key]


## Git
### Remove from repo but stays with you
- git rm -r --cached [what u want to remove]

### Edit commit
- git commit -e