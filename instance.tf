
# User data script for the Jenkins instance (RedHat-based AMI)
locals {
   jenkins_user_data = <<-EOF
    #!/bin/bash
    # This script runs on the EC2 instances at launch.

    # 1. Create a new user 'ansible' with a home directory and bash shell.
    # The password for 'ansible' user is set to 'admin@123'.
    # This is for demonstration purposes; in production, use SSH keys for authentication.
    sudo useradd ansible -m -s /bin/bash -p $(openssl passwd -1 admin@123)

    # 2. Grant 'ansible' user passwordless sudo privileges.
    # This allows the 'ansible' user to run commands with root privileges without being prompted for a password.
    echo 'ansible ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo

    # 3. Enable password authentication for SSH.
    # This sed command robustly finds and sets 'PasswordAuthentication yes',
    # handling commented lines or existing 'no' values.
    sudo sed -i -E 's/^[#[:space:]]*PasswordAuthentication[[:space:]]+(yes|no)/PasswordAuthentication yes/' /etc/ssh/sshd_config

    # 4. Enable keyboard interactive authentication for SSH.
    # This sed command robustly finds and sets 'KeyboardInteractiveAuthentication yes',
    # handling commented lines or existing 'no' values.
    # sudo sed -i -E 's/^[#[:space:]]*KbdInteractiveAuthentication[[:space:]]+(yes|no)/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config

    # 5. Restart the SSH daemon to apply the changes.
    # This ensures that the new SSH configuration (including password and keyboard interactive authentication) takes effect immediately.
    sudo systemctl restart sshd
  EOF

  # User data script for Kubernetes Control Plane and Worker Nodes (Ubuntu-based AMIs)
  ubuntu_user_data = <<-EOF
    #!/bin/bash
    # This script runs on the EC2 instances at launch.

    # 1. Create a new user 'ansible' with a home directory and bash shell.
    # The password for 'ansible' user is set to 'admin@123'.
    # This is for demonstration purposes; in production, use SSH keys for authentication.
    sudo useradd ansible -m -s /bin/bash -p $(openssl passwd -1 admin@123)

    # 2. Grant 'ansible' user passwordless sudo privileges.
    # This allows the 'ansible' user to run commands with root privileges without being prompted for a password.
    echo 'ansible ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo

    # 3. Enable password authentication for SSH.
    # This sed command robustly finds and sets 'PasswordAuthentication yes',
    # handling commented lines or existing 'no' values.
    sudo sed -i -E 's/^[#[:space:]]*PasswordAuthentication[[:space:]]+(yes|no)/PasswordAuthentication yes/' /etc/ssh/sshd_config

    # 4. Enable keyboard interactive authentication for SSH.
    # This sed command robustly finds and sets 'KeyboardInteractiveAuthentication yes',
    # handling commented lines or existing 'no' values.
    sudo sed -i -E 's/^[#[:space:]]*KbdInteractiveAuthentication[[:space:]]+(yes|no)/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config

    # 5. Restart the SSH daemon to apply the changes.
    # This ensures that the new SSH configuration (including password and keyboard interactive authentication) takes effect immediately.
    sudo systemctl restart ssh
  EOF
}


resource "aws_instance" "jenkins" {
  # IMPORTANT: Replace ami-xxxxxxxxxxxxxxxxx with a valid AMI ID for ap-south-1 (Mumbai)
  # This AMI should be RedHat-based (e.g., Amazon Linux, CentOS, RHEL) for the Jenkins playbook.
  ami           = "ami-00e801948462f718a"
  instance_type = "c7i-flex.large"
  key_name      = "universal" # Ensure this key pair exists in your AWS account
  subnet_id     = aws_subnet.subnet1.id # Place in sub1-project
  vpc_security_group_ids = [
    aws_security_group.jenkins-sg.id
  ]
  root_block_device {
    volume_size = 14 # GiB
  }
  user_data = local.jenkins_user_data # Apply user data only to Jenkins

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_instance" "cp-sg" {
  # IMPORTANT: Replace ami-xxxxxxxxxxxxxxxxx with a valid AMI ID for ap-south-1 (Mumbai)
  # This AMI should be Ubuntu-based for the Kubernetes playbook.
  ami           = "ami-00e801948462f718a"
  instance_type = "c7i-flex.large"
  key_name      = "universal" # Ensure this key pair exists in your AWS account
  subnet_id     = aws_subnet.subnet2.id # Place in sub2-project
  vpc_security_group_ids = [
    aws_security_group.cp-sg.id
  ]
  root_block_device {
    volume_size = 20 # GiB
  }
  user_data = local.ubuntu_user_data # Apply user data for Ubuntu instances

  tags = {
    Name = "945-Project-CP"
  }
}

resource "aws_instance" "node1" {
  # IMPORTANT: Replace ami-xxxxxxxxxxxxxxxxx with a valid AMI ID for ap-south-1 (Mumbai)
  # This AMI should be Ubuntu-based for the Kubernetes playbook.
  ami           = "ami-00e801948462f718a"
  instance_type = "c7i-flex.large"
  key_name      = "universal" # Ensure this key pair exists in your AWS account
  subnet_id     = aws_subnet.subnet3.id # Place in sub3-project
  vpc_security_group_ids = [
    aws_security_group.node-sg.id
  ]
  root_block_device {
    volume_size = 20 # GiB
  }
  user_data = local.ubuntu_user_data # Apply user data for Ubuntu instances

  tags = {
    Name = "Node1"
  }
}



