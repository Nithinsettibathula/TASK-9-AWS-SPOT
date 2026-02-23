terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Network Data Sources (Using Default VPC)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2. Security Group (Renamed to v3 to avoid duplicate errors)
resource "aws_security_group" "strapi_sg" {
  name        = "nithin-strapi-sg-task9-v3"
  description = "Security Group for Strapi Task 9"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. ECS Cluster
resource "aws_ecs_cluster" "strapi_cluster" {
  name = "nithin-strapi-cluster-task9"
}

# 4. Capacity Provider Strategy (Enabling FARGATE_SPOT)
resource "aws_ecs_cluster_capacity_providers" "provider" {
  cluster_name       = aws_ecs_cluster.strapi_cluster.name
  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }
}

# 5. Task Definition (Renamed family to v2)
resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "nithin-strapi-task9-v2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  
  # Using the specific role provided by Pearl Thoughts
  execution_role_arn       = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"
  task_role_arn            = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"

  container_definitions = jsonencode([{
    name      = "strapi-container"
    image     = "811738710312.dkr.ecr.us-east-1.amazonaws.com/nithin-strapi-repo:latest"
    essential = true
    portMappings = [{
      containerPort = 1337
      hostPort      = 1337
    }]
  }])
}

# 6. ECS Service (Renamed to v2 to fix Idempotency error)
resource "aws_ecs_service" "strapi_service" {
  name            = "nithin-strapi-service-task9-v2"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.strapi_sg.id]
  }

  depends_on = [aws_ecs_cluster_capacity_providers.provider]
}