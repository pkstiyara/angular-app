
# Security Group

resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "jenkins-security-group"
  }
}



# Instance 

resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.ubuntu.image_id
  instance_type   = "t2.micro"
  key_name        = "jenkins-server-key"
  security_groups = [aws_security_group.jenkins.name]
  user_data       = <<EOF
#!/bin/bash

# Update package index
sudo apt-get update

# Install Java 11
sudo apt-get install -y openjdk-11-jdk

# Add Jenkins package repository
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update

# Install Jenkins LTS
sudo apt-get install -y jenkins

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins service to start on boot
sudo systemctl enable jenkins

# Check the status of Jenkins service
sudo systemctl status jenkins
EOF

  tags = {
    "Name" = "Jenkins-Server"
  }
}

#################################################################
#                         ELASTIC IP
#################################################################

resource "aws_eip" "jenkins-eip" {
  vpc = true
  instance = aws_instance.jenkins.id
}

