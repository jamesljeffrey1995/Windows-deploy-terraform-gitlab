<h2>Install gitlab server and set up runner (RHEL8):</h2>
<h3>Installing gitlab:</h3></br>
  
```
sudo dnf install firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo dnf install -y curl policycoreutils openssh-server perl
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo systemctl reload firewalld
sudo dnf install postfix
sudo systemctl enable postfix
sudo systemctl start postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="http://<YOUR-IP>" dnf install -y gitlab-ee
```
<h3>Installing and registering runner:</h3>

```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E yum install gitlab-runner
sudo gitlab-runner register
```
<h3>You will encounter when registering the runner some places you need to input information:</h3>
<b>Your URL:</b></br>

![ip](https://i.imgur.com/x7ayoln.png)<br>
Here you will enter your ip of your VM:<br>
```http://1.1.1.1```<br>

<b>Your Token:</b><br>
![token](https://imgur.com/NUukZYb.png)<br>
Here you will enter your registration token:<br>
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






<b>Prerequisites:</b><br>
WinRM <br>
Python3 <br>
Ansible <br>
Terraform <br>
<i>This can all be installed during the ci/cd pipeline if you make a stage for it</i><br>

<b>ENV:</b><br>
Variable AWS_ACCESS_KEY_ID <br>
Variable AWS_SECRET_ACCESS_KEY <br>
File pem #This is the contents of a decrypted pem file <br>
