module "ecs_container_definition" {
  source = "terraform-aws-modules/ecs/aws//modules/container-definition"
  name      = "example"
  # cpu       = 512
  # memory    = 1024
  # essential = true
  privileged = false
  image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
  port_mappings = [
    {
      name          = "ecs-sample"
      containerPort = 80
      protocol      = "tcp"
    }
  ]
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
