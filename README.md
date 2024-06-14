# Student_Form_terraform

#Install AWS CLI<br /> 
''''''''''''''''''<br /> 
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

'''''''''''''''''<br /> 

#Create Aws Profile <br /> 
'''''''''''''''''''''''''<br /> 
aws configure --profile <profile_name>
''''''''''''''''''''''''''<br /> 

#Install Terraform in Ubuntu <br /> 
'''''''''''''''''''''''<br /> 
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
'''''''''''''''''''''''<br /> 

#Clone the repository <br /> 
'''''''''''''''''''''''''<br /> 
sudo apt install git -y 
git clone <repo link >
''''''''''''''''''''''''<br /> 

