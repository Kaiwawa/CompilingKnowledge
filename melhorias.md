# Melhorias e Boas Práticas na IaC (Terraform)

Após análise dos arquivos localizados em `Deploy/Terraform/*`, identifiquei diversas oportunidades de melhoria arquitetural e de boas práticas para garantir que a infraestrutura seja robusta, segura e aderente ao mercado. 

## 1. Configurações de Rede (VPC e Security Groups)
- **VPC e Subnets Customizadas:** Atualmente as instâncias EC2 não especificam onde serão lançadas, o que fará com que utilizem a **VPC Default** da AWS. A melhor prática é criar uma VPC dedicada (com `aws_vpc`), Subnets (Públicas/Privadas), Internet Gateway e Route Tables para o cluster K3s.
- **Security Groups:** Não há Security Groups definidos para as instâncias. Isso significa que elas herdarão o SG default, que pode não permitir acesso externo ou expor a máquina de forma insegura.
  - **Requisito para o Ansible:** Liberar a porta `22` (SSH) apenas para o seu IP.
  - **Requisito para o K3s:** Liberar as portas de comunicação do cluster entre os nós (ex: TCP 6443 para a API, TCP/UDP 8472 para Flannel, portas de NodePort, etc).

## 2. Acesso e Autenticação (Acesso SSH Crítico)
- **Key Pair Ausente:** As instâncias EC2 definidas nos módulos (`k8s_controller` e `k8s_workers`) **não possuem** o parâmetro `key_name`. Sem isso, a AWS não injetará a sua chave pública na VM, e o **Ansible não conseguirá se conectar por SSH** para realizar a configuração.
  - *Ação recomendada:* Criar um recurso `aws_key_pair` ou referenciar uma chave existente usando o parâmetro `key_name` na EC2.

## 3. Parametrização e Hardcoding
- **AMI Hardcoded:** O uso de AMIs fixas (ex: `ami-0b6c6ebed2801a5cb`) pode causar problemas, pois AMIs são atualizadas e desativadas com o tempo (ou podem diferir por região). 
  - *Solução:* Usar um **Data Source (`data "aws_ami"`)** para buscar dinamicamente a AMI mais recente do Ubuntu (ex: 22.04 LTS).
- **Tipagem de Variáveis:** Os arquivos `var-controllers.tf` e `var-workers.tf` definem variáveis, mas **sem tipo ou descrição**. Adicionar `type = number`, `type = string` e `description` é essencial para documentação e validação de input.

## 4. Estrutura e Passagem de Providers
- **Provider Alias:** O `main.tf` declara um provider `aws` com apelido `alias = "east"`, mas as instâncias nos módulos referenciam `region = aws.east` de maneira hardcoded nas configurações de região dentro da EC2 (o atributo correto na EC2 nem é `region`, instâncias não possuem o argumento `region` e sim o provider configurado). Além disso, instâncias usam o provider passado para o módulo. 
  - *Solução:* Passar o provider explicitamente no bloco de chamada do módulo no `modules.tf` usando `providers = { aws = aws.east }` e remover tentativas de referenciar `region = aws.east` de dentro da resource EC2.

## 5. Arquitetura K3s / Resiliência
- **IAM Roles (Instance Profile):** Para o caso de o Kubernetes precisar interagir com a AWS (ex: provisionar Persistent Volumes EBS ou Load Balancers), as instâncias precisam ter uma `iam_instance_profile` atrelada a elas com as políticas corretas.
- **Tags Estratégicas:** Adicionar tags padronizadas em todos os recursos, como `Environment = "Homelab"`, `ManagedBy = "Terraform"`, para facilitar filtro de custos no AWS Billing.

## 6. Estado do Terraform
- **State Locking:** O S3 já foi configurado para armazenar o `terraform.tfstate`, excelente. Contudo, para evitar problemas de concorrência num ambiente profissional ou CI/CD, deve-se adicionar uma tabela do **DynamoDB** ao backend para realizar o *State Locking*.
