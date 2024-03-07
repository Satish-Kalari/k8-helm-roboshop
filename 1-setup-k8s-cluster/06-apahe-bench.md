# installing Apache Benchmark tool for load testing 
in workstation super putty


to install
sudo yum install httpd-tools -y

to test:
ab -c 1000 -n 100000 -k http://roboshop.projoy.store/
