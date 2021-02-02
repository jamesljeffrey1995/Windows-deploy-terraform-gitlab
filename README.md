<h1> Deploy a Windows VM using Ansible, Terraform and Gitlab CI/CD </h1>
<h2>Contents</h2>

<ul>
  <li>
    
   [Prerequisites](#prerequisites)
    
  </li>
  <li>
    
   [Install gitlab server and set up runner](#install-gitlab-server-and-set-up-runner)
  <ul>
  <li>
    
   [Installing Gitlab](#installing-gitlab)
    
  </li>
  <li>
    
   [How to use HTTPS with gitlab](#using-https-with-self-signed-certificate)
    
  </li>
  <li>
    
   [Installing and registering runner:](#installing-and-registering-runner)
    
  </li>
  </ul>
  <li>
  
   [Enviroment Variables and Files](#enviroment-variables-and-files)
     
  </li>
  </li>
</ul>

<h2>Prerequisites:</h2>
WinRM <br>
Python3 <br>
Ansible <br>
Terraform <br>
<i>This can all be installed during the ci/cd pipeline if you make a stage for it</i><br>

<h2>Install gitlab server and set up runner:</h2>

<h3>Installing gitlab:</h3></br>
  
```
sudo dnf install -y firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo dnf install -y curl policycoreutils openssh-server perl
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo systemctl reload firewalld
sudo dnf install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="https://<YOUR-IP>" dnf install -y gitlab-ee #change this to http if you dont want to use HTTPS
```
<h2>Using HTTPS with self signed certificate</h2>

```
sudo dnf install -y nginx vim mlocate
cd /etc/gitlab/ ; sudo openssl genrsa -aes128 -out server.key 2048
sudo openssl rsa -in server.key -out server.key
sudo openssl req -new -days 3650 -key server.key -out server.csr
sudo openssl x509 -in server.csr -out server.crt -req -signkey server.key -days 3650
```
You will be prompted after pressing enter, enter with the relevant information such like the following image, if space is completely blank then it is to be left blank:

![ssl](https://imgur.com/FYrbA7N.png)

Then enter ```sudo chmod 400 server.*```<br>
You then need to vim into the rb file ```sudo vim /etc/gitlab/gitlab.rb```, copy and paste the following code in the same format as the picture below:
```
letsencrypt['enable'] = false
nginx['enable'] = true
nginx['client_max_body_size'] = '250m'
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/server.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/server.key"
nginx['ssl_protocols'] = "TLSv1.2 TLSv1.3"
```
![gitRB](https://imgur.com/tvC1fxY.png)

Save and quit, press esc and type ```:wq```, copy and paste ```sudo updatedb``` <br>
Enter ```sudo gitlab-rake gitlab:check``` to check if everything is installed correctly. You can access the gitlab server by https://YOURIP



<h3>Installing and registering runner:</h3>

```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E yum install gitlab-runner
sudo gitlab-runner register
```
<h3>You will encounter when registering the runner some places you need to input information:</h3>
<b>Your URL:</b></br>

![ip](https://i.imgur.com/x7ayoln.png)<br>
Here you will enter your ip of your VM, an example below:<br>
```http://1.1.1.1```<br>

<b>Your Token:</b><br>
![token](https://imgur.com/NUukZYb.png)<br>
Here you will enter your registration token, an example below:<br>
```Nx_2YeKNQJRx8eXdhxrV```<br>
<b>Here is how the token is found:</b><br>
Click where the red square is, this is the admin area:
![git1](https://imgur.com/TPyvBXA.png)<br>
Then click runners
![git2](https://imgur.com/HX8TOIK.png)<br>
Then copy your registration token:<br>
![git3](https://imgur.com/feviRPd.png)<br>

<b>Your executor:</b><br>
![executor](https://imgur.com/EXs6Lcl.png)
This is how your code is executed, in this case you will type ```shell```<br>

If successfull, go back to admin area and then runners. You should see this:
![successfull](https://imgur.com/3hmKixk.png)



<h3>Enviroment variables and files:</h3>
Variable AWS_ACCESS_KEY_ID <br>
Variable AWS_SECRET_ACCESS_KEY <br>
File pem #This is the contents of a decrypted pem file <br>
