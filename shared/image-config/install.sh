et -exuo pipefail

### Install packages
apt-get update && apt-get install -y \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    rubygems \
    ruby-dev \
    apt-transport-https \
    ca-certificates \
    curl \
    dnsutils \
    librabbitmq-dev \
    lsb-release \
    mysql-client \
    software-properties-common \
    unzip \
    jq

# Install pip packages necessary for some Terraform provider dependencies
pip3 install \
   google-auth==1.3.0 \
   google-api-python-client==1.6.4 \
   google-cloud==0.32.0 \
   oauth2client==3.0.0

### Install google-cloud SDK - https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
# Create environment variable for correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-
sdk.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Update the package list and install the Cloud SDK
apt-get update && apt-get install -y google-cloud-sdk

Copy binaries to a location used by some pipelines
mkdir -p /google-cloud-sdk/bin/
ln -s /usr/bin/gcloud /google-cloud-sdk/bin/gcloud
ln -s /usr/bin/gsutil /google-cloud-sdk/bin/gsutil
chmod -R 755 /google-cloud-sdk/bin

### Add gcloud configuration used for image baking
gcloud config configurations create packer --no-activate

### Install Docker - https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker repositories
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" >> /etc/apt/sources.list.d/additiona
l-repositories.list
echo "deb http://ftp-stud.hs-esslingen.de/ubuntu xenial main restricted universe multiverse" >> /etc/apt/sources.li
st.d/official-package-repositories.list

# Add keyserver
apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys 437D05B5

# Update repository and install Docker-CE
apt-get update && apt-get install -y docker-ce

### Install Packer
cd /usr/local/bin
curl -LO https://releases.hashicorp.com/packer/1.3.2/packer_1.3.2_linux_amd64.zip
unzip packer_1.3.2_linux_amd64.zip
rm -f packer_1.3.2_linux_amd64.zip

### Install Terraform Landscape

#gem install terraform_landscape
### Install Terraform
cd /usr/local/bin
curl -LO https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
unzip terraform_0.11.10_linux_amd64.zip
rm -f terraform_0.11.10_linux_amd64.zip

### Install Terraform GSuite Provider
plugins_dir="/home/$JENKINS_USER/.terraform.d/plugins"
mkdir -p $plugins_dir && cd $plugins_dir
curl -L https://github.com/DeviaVir/terraform-provider-gsuite/releases/download/v0.1.9/terraform-provider-gsuite_0.
1.9_linux_amd64.tgz | tar xzv

### Install Terragrunt
cd /usr/local/bin
curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v0.17.2/terragrunt_linux_amd64
mv terragrunt_linux_amd64 terragrunt
chmod 755 terragrunt