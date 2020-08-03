
###
# Security Group
# Allowing ALL traffic from ALL IPs. 
# This is a bad idea. Don't do this irl. 
# Doing it for proof of concept only.
###
resource "aws_security_group" "give_me_traffic" {
  name        = "give_me_traffic"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow all traffic"
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
}

resource "aws_key_pair" "my_key" {
  key_name   = "id_rsa"
  public_key = var.public_key
}

###
# IAM configuration to give ECR access. 
###
resource "aws_iam_role" "access_ecr_role" {
  name               = "access_ecr_role"
  assume_role_policy = file("files/assumerole.json")
}

resource "aws_iam_instance_profile" "ecr_profile" {
  name = "ecr_profile"
  role = aws_iam_role.access_ecr_role.name
}

resource "aws_iam_policy" "policy" {
  name   = "access_ecr_policy"
  policy = file("files/ecrpolicy.json")
}

resource "aws_iam_policy_attachment" "ecr_policy_attach" {
  name       = "ecr_policy_attach"
  roles      = ["${aws_iam_role.access_ecr_role.name}"]
  policy_arn = aws_iam_policy.policy.arn
}

###
# Instance running the webapp
###
resource "aws_instance" "application" {
  ami                  = "ami-07c8bc5c1ce9598c3"
  instance_type        = "t2.micro"
  security_groups      = ["${aws_security_group.give_me_traffic.id}"]
  subnet_id            = aws_subnet.public.id
  key_name             = aws_key_pair.my_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ecr_profile.name
  tags = {
    "version_number" : var.version_number
  }

  lifecycle {
    create_before_destroy = true
  }

  ###
  # Commands run on EC2 instance
  # Install + log in to docker, pull latest version of date-and-time image. 
  # who needs a whole ec2 instance for one docker image? This guy. 
  ###
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo $(aws ecr get-login --no-include-email --region us-east-2)",
      "sudo docker run -d -p 5000:5000 493700338917.dkr.ecr.us-east-2.amazonaws.com/date-and-time:latest"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_instance.application.public_ip
    }
  }
}

###
# Load balancer for web app
###
resource "aws_elb" "application_elb" {
  subnets = [aws_subnet.public.id]

  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:5000/"
    interval            = 30
  }

  instances       = [aws_instance.application.id]
  security_groups = ["${aws_security_group.give_me_traffic.id}"]

  lifecycle {
    create_before_destroy = true
  }
}