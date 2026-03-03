## What I learned today (Day 2):

### AWS VPC:
--> Understand how to build a Virtual Private Cloud from scratch using Terraform.
--> Created an Internet Gateway, Route Tables, and a Public Subnet for the cluster.
--> Created Security Groups explicitly allowing SSH (22), K3s API (6443), and Flannel VXLAN (8472).

### The "Cost-Saving" Revelation (K3s over K8s):
--> **Crucial decision:** Running a full Kubernetes cluster requires instances like `t3.small` (out of the free tier) which *will cost money*. 
--> To keep the budget strictly at $0.00, we shifted the architecture to use **K3s (Lightweight Kubernetes)**. This allows the Control Plane and Workers to run comfortably on `t2.micro` or `t3.micro` instances, which offer 750 free hours per month!

### Ansible:
--> Started diving into Ansible to automate the node configurations.
--> Created an `ansible.cfg` to disable strict host key checking and define standard behaviors.
--> Set up an `inventory.ini` grouping the nodes into `[control_plane]` and `[workers]`.
--> Created my first playbook (`setup.yml`) to ping the nodes and install initial dependencies using apt.

### To-do Tomorrow (Day 3):
-> Spin up the EC2 instances using Terraform.
-> Run the Ansible playbook to automatically deploy the K3s Control Plane and join the Workers.
-> Interact with the cluster via `kubectl`.

### Tips:
- Always use Security Groups wisely! Only open port 22 and 6443 to your own IP if possible, rather than `0.0.0.0/0`.
- Use `--help` for terraform and ansible commands if you get stuck.

Good work today! 🚀
