provider "aws" {
  region                  = "us-west-2"
  access_key              = var.access_key
  secret_key              = var.secret_key
  assume_role {
    role_arn             = "arn:aws:iam::257394455086:role/duyle392002"
    session_name         = "TerraformAmplifySession"
  }
}
resource "aws_amplify_app" "hello_world_amplify" {
  name       = var.app_name
  repository = var.repository
  access_token             = var.access_token
  enable_branch_auto_build = true
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    Name           = "hello-world"
    Provisioned_by = "Terraform"
  }
}

resource "aws_amplify_branch" "amplify_branch" {
  app_id            = aws_amplify_app.hello_world_amplify.id
  branch_name       = var.branch_name
  enable_auto_build = true
}

# resource "aws_amplify_domain_association" "domain_association" {
#   app_id                = aws_amplify_app.hello_world_amplify.id
#   domain_name           = var.domain_name
#   wait_for_verification = false

#   sub_domain {
#     branch_name = aws_amplify_branch.amplify_branch.branch_name
#     prefix      = var.branch_name
#   }

# }
# resource "aws_amplify_domain_association" "my_domain" {
#   app_id      = aws_amplify_app.my_app.app_id
#   domain_name = "example.com"

#   sub_domain_setting {
#     prefix     = "www"
#     branch_name = aws_amplify_app.my_app.default_branch
#   }
# }
