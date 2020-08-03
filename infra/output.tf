output "elb_ip" {
  value = aws_elb.application_elb.dns_name
}

output "instance_ip" {
  value = aws_instance.application.public_ip
}