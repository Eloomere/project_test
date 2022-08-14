resource "aws_security_group" "mysec" {
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = aws_default_vpc.default.id

    #"aws_security_group_rule" "allow_http_inbound"  {}


    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
         from_port        = 22
         to_port          = 22
         protocol         = "tcp"
         cidr_blocks      = ["0.0.0.0/0"]
  }

    egress   {
        from_port = 0
        to_port = 0
        protocol = "-1" 
        cidr_blocks  = ["0.0.0.0/0"] 
    
}
      
  
  } 
        

#security group ends here

resource "aws_instance" "amazon_linux" {

  ami                    = "ami-098e42ae54c764c35" 
  instance_type          = "t2.micro"
  key_name               =  "zinnykey"
  security_groups        = ["${aws_security_group.mysec.name}"]
  user_data              = <<-EOT
               #!/bin/bash
               sudo apt update -y 
               sudo apt install nginx -y &&
               sudo systemctl enable nginx
               sudo systemctl start nginx 
               echo "welcome, my name is Elo from $(hostname -f)" > /var/www/html/index.html 
               EOT           

  tags = {
    Name = "webserver"
    Terraform   = "true"
    Environment = "dev"
  }
}