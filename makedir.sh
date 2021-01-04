if [ -d /tmp/${GITLAB_USER_LOGIN} ]; then
   echo "Directory already exists"
else
   mkdir /tmp/${GITLAB_USER_LOGIN} 
fi
