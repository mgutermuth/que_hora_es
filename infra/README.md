# que_hora_es - infra

Creates a VPC with a single subnet and attached Internet Gateway for use with a blue/green deploy of a simple web application with load balancer. This is done while limiting resources to what is available in the AWS free tier (excluding ELB)

The application deploy is done in a blue/green manner in that the new instance is stood up and is ready for traffic before the old instance is deleted. However there is no way to prevent the old 'blue' instance from not being deleted and being able to switch back and forth. 