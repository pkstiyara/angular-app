
# Security Group

resource "aws_security_group" "sonar-server" {
  name        = "sonar-server-sg"
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

# This is not a good practice but i am testing some here 
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "server-security-group"
  }
}



# Instance 

resource "aws_instance" "sonar-server" {
  ami             = data.aws_ami.ubuntu.image_id
  instance_type   = "t2.medium"
  key_name        = "terraform"
  security_groups = [aws_security_group.sonar-server.name]
  user_data       = <<EOF
#!/bin/bash

# Update package index
sudo apt update && apt upgrade -y


# Install Java 11
sudo apt update
sudo apt install -y openjdk-11-jdk

# Set the JAVA_HOME environment variable
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# Download and install SonarQube Server
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip
unzip sonarqube-8.9.2.46101.zip -d /opt/sonarqube/
/opt/sonarqube/bin/sonar.sh start

echo "SonarQube Server installation complete."


EOF

  tags = {
    "Name" = "Sonar-Server"#!/bin/bash

# Install Java 11
sudo apt update
sudo apt install -y openjdk-11-jdk

# Set the JAVA_HOME environment variable
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# Download and install SonarQube Server
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip
unzip sonarqube-8.9.2.46101.zip -d /opt/sonarqube/
/opt/sonarqube/bin/sonar.sh start

echo "SonarQube Server installation complete."

  }
}

resource "aws_eip" "sonar-eip" {
  vpc = true
  instance = aws_instance.sonar-server.id
}



