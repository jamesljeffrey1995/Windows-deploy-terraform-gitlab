<h2>Install gitlab server and set up runner (RHEL8):</h2><br>
```
sudo dnf install firewalld
```


<b>prerequisites:</b><br>
WinRM <br>
Python3 <br>
Ansible <br>
Terraform <br>
<i>This can all be installed during the ci/cd pipeline if you make a stage for it</i><br>

<b>ENV:</b><br>
Variable AWS_ACCESS_KEY_ID <br>
Variable AWS_SECRET_ACCESS_KEY <br>
File pem #This is the contents of a decrypted pem file <br>
