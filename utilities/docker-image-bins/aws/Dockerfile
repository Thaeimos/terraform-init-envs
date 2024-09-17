FROM ubuntu:22.04

# Variables
ARG TF_VERSION="1.9.2"
ARG TF_HOME=/home/aws-terra

# Common packages
RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg apt-utils python3 git vim jq bash-completion gnupg2 software-properties-common lsb-release gnupg wget unzip less groff glibc-source 
## YQ
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
RUN chmod a+x /usr/local/bin/yq

# Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN kubectl version --client

# Add completions to Bash 
RUN echo 'source /usr/share/bash-completion/bash_completion' >> /root/.bashrc
RUN echo 'source <(kubectl completion bash)' >> /root/.bashrc

# Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
RUN echo 'source <(helm completion bash)' >> /root/.bashrc

# Terraform
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_$(dpkg --print-architecture).zip
RUN unzip terraform_${TF_VERSION}_linux_$(dpkg --print-architecture).zip
RUN mv terraform /usr/local/bin/
RUN echo 'complete -C /usr/local/bin/terraform terraform' >> /root/.bashrc

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
# Auto-complete
RUN echo 'complete -C /usr/local/bin/aws_completer aws ' >> ~/.bashrc

# AWS login
COPY secrets/login.secrets /tmp/
RUN mkdir ~/.aws
## Template config
RUN <<EOF cat >> ~/.aws/config
[default]
region=AWS_REGION
output=json
EOF
### Substitutions
RUN export VARIABLE=$(yq eval '.aws.region' /tmp/login.secrets) ; sed -i -r "s/AWS_REGION/${VARIABLE}/g" ~/.aws/config
## Template creds
RUN <<EOF cat >> ~/.aws/credentials
[default]
aws_access_key_id=KEY_ID
aws_secret_access_key=KEY_ACCESS
EOF
### Substitutions
RUN export VARIABLE=$(yq eval '.aws.access' /tmp/login.secrets) ; sed -i -r "s/KEY_ID/${VARIABLE}/g" ~/.aws/credentials
RUN export VARIABLE=$(yq eval '.aws.secret' /tmp/login.secrets) ; sed -i -r "s;KEY_ACCESS;${VARIABLE};g" ~/.aws/credentials

WORKDIR ${TF_HOME}

# GIT
## Avoid "fatal: detected dubious ownership in repository" message
RUN git config --global --add safe.directory ${TF_HOME}
## Configure GIT to fetch private modules
RUN export GITHUB_USER=$(yq eval '.git.user' /tmp/login.secrets) ; export GITHUB_PAT=$(yq eval '.git.token' /tmp/login.secrets) ; git config --global url."https://${GITHUB_USER}:${GITHUB_PAT}@github.com/Thaeimos".insteadOf "https://github.com/Thaeimos"
## Configure email and name
RUN export GITHUB_EMAIL=$(yq eval '.git.email' /tmp/login.secrets) ; git config --global user.email "${GITHUB_EMAIL}"
RUN export GITHUB_NAME=$(yq eval '.git.name' /tmp/login.secrets) ; git config --global user.name "${GITHUB_NAME}"

# Remove secrets
RUN rm /tmp/login.secrets

ENTRYPOINT ["/bin/bash"]