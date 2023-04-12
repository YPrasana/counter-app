#data resources #
#service manager parameter
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#declare availability zone data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "template_file" "user_data" {
  template = <<EOF
  #!/bin/bash
    yum update -y
    yum install -y nginx

    # Install Node.js and npm
    curl -sL https://rpm.nodesource.com/setup_14.x | bash -
    yum install -y nodejs

    # Configure Nginx
    systemctl start nginx
    systemctl enable nginx
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    cat <<EOF >/etc/nginx/nginx.conf
      user  nginx;
      worker_processes  auto;
      error_log  /var/log/nginx/error.log warn;
      pid        /var/run/nginx.pid;
      events {
          worker_connections  1024;
      }
      http {
          include       /etc/nginx/mime.types;
          default_type  application/octet-stream;
          log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                            '$status $body_bytes_sent "$http_referer" '
                            '"$http_user_agent" "$http_x_forwarded_for"';
          access_log  /var/log/nginx/access.log  main;
          sendfile        on;
          #tcp_nopush     on;
          keepalive_timeout  65;
          #gzip  on;
          server {
              listen       80;
              server_name  localhost;
              location / {
                  proxy_pass  http://127.0.0.1:3000;
                  proxy_http_version 1.1;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection 'upgrade';
                  proxy_set_header Host $host;
                  proxy_cache_bypass $http_upgrade;
              }
              error_page 404 /404.html;
                  location = /40x.html {
              }
              error_page 500 502 503 504 /50x.html;
                  location = /50x.html {
              }
          }
      }

    # Install and start the Node.js application
    aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/index.html /home/ec2-user/index.html
    aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/style.css /home/ec2-user/style.css
    aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/app.js /home/ec2-user/app.js
    cd /home/ec2-user/
    chown ec2-user index.html
    chown ec2-user style.css
    chown ec2-user app.js
    npm install
    npm start app.js
  EOF
}

  # #!/bin/bash
  #   sudo yum install aws-cli -y
  #   sudo yum update -y
  #   sudo amazon-linux-extras install -y nginx1
  #   sudo amazon-linux-extras install epel
  #   sudo yum install nodejs
  #   sudo amazon-linux-extras enable nginx1
  #   sudo systemctl enable nginx
  #   sudo systemctl start nginx
    
  #   aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/index.html /home/ec2-user/index.html
  #   aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/style.css /home/ec2-user/style.css
  #   aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/app.js /home/ec2-user/app.js
  #   sudo rm /usr/share/nginx/html1/index.html
  #   sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
  #   sudo cp /home/ec2-user/style.css /usr/share/nginx/html/style.css
  #   sudo cp /home/ec2-user/app.js /usr/share/nginx/html/app.js
  #   sudo chmod -R 755 /usr/share/nginx/html/*
  #   sudo 
  #   EOF

