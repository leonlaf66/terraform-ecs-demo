module "nodejs_ecs_service" {
  source = "git::https://github.com/leonlaf66/terraform-ecs-module?ref=v1.0.0"

  app_name       = "app-nodejs"
  aws_region     = var.aws_region
  
  shared_ecr_repository_url = "286005841113.dkr.ecr.us-east-1.amazonaws.com/leon-demo-odoo-dev"
  ecs_execution_role_arn    = aws_iam_role.ecs_execution_role.arn
  ecs_task_role_arn         = aws_iam_role.ecs_task_role.arn
  
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids
  
  services = {
    "web" = {
      image_tag = local.final_tag
      cpu       = 256
      memory    = 512
      
      port_mappings = [{
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      }]
      
      health_check = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
        interval    = 20
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
      
      assign_public_ip = true
    }
  }

  ingress_rules = [
    {
      description = "Allow HTTP access to Node.js app"
      from_port   = 3000
      to_port     = 3000
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]
}