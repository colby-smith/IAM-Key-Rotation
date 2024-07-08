# IAM-Key-Rotation
## About
This is a terraform deployment for automating the rotation of your own AWS access and secret keys every month. It uses python's boto3 client library to interact and change the infrastructure in AWS. I've coded the script to list through every IAM user, delete the security credentials, create new ones and store the new ones in Systems manager's parameter store. A cost-efficient secure way of keeping user credentials safe without using secrets manager.

## Architecture diagram
![IAM-Key-Rotation](https://github.com/colby-smith/IAM-Key-Rotation/assets/160542058/8b623a98-08ce-4500-b8bb-649c995f2208)



## Prerequisites
To use this program effectively, make sure you have installed:
* bash or zsh
* AWS CLI
* Terraform
* Python 3.12.2
  
## Installing WSL (Windows Subsystem for Linux)

1. Copy and paste the code below into your shell and hit enter.
```
wsl --install
```
3. Wait for the downloads to be complete, then restart your computer.

4. After restarting your computer, you should see an "Ubuntu" Window open automatically once you log back in. If you don't, search for the "Ubuntu" or "WSL" program in the start menu and launch it.

5. The window will prompt you to enter a username and password. Make sure you remember these! These are the credentials for your Linux user.

## Installing the AWS CLI

1. First make sure you have unzip and zip installed, if not run the commands below:
```
sudo apt install unzip
```
```
sudo apt install zip
```
2. Finally, run the command below:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
3. If you already have the AWS CLI installed, you can update it using the command below:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
```

## Installing Terraform

1. Ensure that your system is up-to-date, and you have installed the GnuPG, software-properties-common, and curl packages installed.

2. First, run the command below:
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```
3. Then, Install the HashiCorp GPG key.
```
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```
4. Verify the key's fingerprint.
```
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```

6. Add the official HashiCorp repository to your system. The lsb_release -CS command finds the distribution release codename for your current system, such as buster, groovy, or SID.
```
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```
7. Install Terraform from the new repository.
```
sudo apt-get install terraform
```
8a. Finally, verify that the installation worked by opening a new terminal session and listing Terraform's available subcommands.
```
terraform -help plan
```
8b. Optionally, if you're using Bash or Zsh, you can instal tab completion below.
```
terraform -install-autocomplete
```
## Installing python 3.12.2
If you're on Linux, there are some dependencies you'll need before installing pyenv. Run these commands to install them:

1. Only run these if you're using a Linux System.
```
sudo apt update
sudo apt install -y build-essential zlib1g-dev libssl-dev
sudo apt install -y libreadline-dev libbz2-dev libsqlite3-dev libffi-dev
```
2. Run this to install pyenv with webi.
```
curl -sS https://webi.sh/pyenv | sh
```
3. Open your ~/.bashrc file in VS Code. You can do so by typing:
```
code ~/.bashrc
```
If you're using a Mac.
```
code ~/.zshrc
```
4. Add these lines to the bottom of the file in this order:
```
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

5. Finally close and reopen your terminal.

## Usage
To use this program yourself, make sure you have the following prerequisites installed. Then follow the steps:

1. Clone the Repository:
```
git clone https://github.com/colby-smith/IAM-Key-Rotation.git
```
```
cd IAM-Key-Rotation
```
2. Configure AWS CLI to your account using your own credentials:
```
aws configure
```
3. Initialise terraform in the working directory:
```
terraform init
```
4a. Plan the deployment (optional):
```
terraform plan
```
4b. Apply the deployment:
```
terraform apply
```
5. Verify the deployment has worked in your AWS console the cron job is configured to run the first of every month 10am UTC, but this can be changed in the eventbridge.tf file.
