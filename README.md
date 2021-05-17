# Jenkins Master Slave Node configuration on RHEL-8/Amazon Linux 2 /CentOS /Fedora with HTTPD and triggering Jenkins with GitHub


### Jenkins: Jenkins is an open-source automation tool written in Java with plugins built for Continuous Integration purposes. Jenkins is used to build and test your software projects continuously making it easier for developers to integrate changes to the project, and making it easier for users to obtain a fresh build.
 
 * **Configure two AWS EC2  instances one for master and other one for slave with following Scripts or you can use above file viceversa in advance section as shown in image**

    ![image](https://user-images.githubusercontent.com/65442845/118155876-54ddfc80-b436-11eb-8026-397530df19c7.png)

 * **Add Security Group open port 22 for ssh, port 80 for httpd and port 8080 for jenkins**

    ![image](https://user-images.githubusercontent.com/65442845/118176906-9dee7a80-b44f-11eb-8220-8b137d644e77.png)



### FOR MASTER

```
    #!/bin/bash
    sudo yum install wget -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key   
    sudo yum install jenkins java-1.8.0-openjdk-devel -y   
    sudo systemctl daemon-reload
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo yum install git -y
    sudo yum upgrade -y
```


### FOR SLAVE

``` #!/bin/bash
    sudo yum install jenkins java-1.8.0-openjdk-devel -y
    sudo yum install git -y
    sudo yum upgrade
    sudo yum install httpd -y   
    sudo chkconfig httpd on
    sudo service httpd start
    sudo service httpd enable
```
 * SSH into Master Node and check status of jenkins
```
    sudo systemctl status jenkins
```
   ![S4](https://user-images.githubusercontent.com/65442845/118177634-91b6ed00-b450-11eb-80bb-9dc112e38d72.PNG)

 * hit MasterIP:8080
 
    ![Screenshot (960)](https://user-images.githubusercontent.com/65442845/118179251-a7c5ad00-b452-11eb-8a28-0fa8a45b3998.png)

 * copy the path of the stored adminstrator password
```
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
 *you will see password like this 3efca61c38c84e73aa6a6a12b1c4c191 copy the password and paste in Jenkins GUI as shown in screenshot*
 
   ![S5](https://user-images.githubusercontent.com/65442845/118178287-67196400-b451-11eb-80ae-e47c4f3f95c3.PNG)
     
  
 *Install suggested Plugins*
 
 ![Screenshot (966)](https://user-images.githubusercontent.com/65442845/118179313-c0ce5e00-b452-11eb-8c9a-90e0eb1c8099.png)
 
 *Create First Admin User*
  
 *Username:	Sudhanshu*
  
 *Password:	••••••*  
  
 *Confirm password:	••••••*
  
 *Full name:	SUDHANSHU TRIPATHI*
  
 *E-mail address:	sudhanshutripathi541998@gmail.com*

 * SSH to jenkins slave node
 * Then run the below commands to setup a new user   
 
```
    useradd jenkins-slave-01
    passwd ******** 
    sudo su - jenkins-slave-01 
    ssh-keygen -t rsa -N "" -f /home/jenkins-slave-01/.ssh/id_rsa 
    cd .ssh
    cat id_rsa.pub > authorized_keys
    chmod 700 authorized_keys 
```
![S6](https://user-images.githubusercontent.com/65442845/118178555-b8295800-b451-11eb-816e-ca1347e82cbf.PNG)

 * Next we have to add Add new user into sudoers file for that use below command it opens a file add the below content into the file by pressing 'i' then add the content then save the file by pressing button 'esc' then ':' then 'wq' add this line anywhere in the file (Have to do like this press esc-> :wq -> Enter)
```
    sudo visudo
```
 *jenkins-slave-01 ALL=(ALL) NOPASSWD: ALL* 
 
![S7](https://user-images.githubusercontent.com/65442845/118178689-ead35080-b451-11eb-9c76-664aec93be28.PNG)

 * Now SSH into your Master Node Instance and Configure
 * Then Run the below commands as root
 ```
    sudo su - root
    mkdir -p /var/lib/jenkins/.ssh      #With the help of mkdir -p command you can create sub-directories of a directory. It will create parent directory first, if it doesn't exist. But if it already exists, then it will not print an error message and will move further to create sub-directories.
    cd /var/lib/jenkins/.s
    ssh-keyscan -H SLAVENODEPRIVATEIP >>/var/lib/jenkins/.ssh/known_hosts   
    chown jenkins:jenkins /var/lib/jenkins/.ssh/known_hosts
    chmod 700 /var/lib/jenkins/.ssh/known_hosts
    ls -l
```    
![S8](https://user-images.githubusercontent.com/65442845/118178767-0a6a7900-b452-11eb-826e-00eace94003b.PNG)

 * Then Goto jenkins Dash Board

   -> Manage Jenkins

   -> Manage Nodes and Clouds

   -> NewNode Add it as Permanent Agent
 
   -> Add Description
 
   -> Add No of executers
 
   -> Remote root directory [/home/jenkins-slave-01]
 
   -> Add a Label Ex: java
 
   -> Usage As much as possible
 
   -> In launch method: select Launch agent via SSH
 
   -> In Host section :  we have to provide the private IP of the slave
    
    ![Screenshot (967)](https://user-images.githubusercontent.com/65442845/118179516-08ed8080-b453-11eb-844b-10302937080c.png)
 
   -> Add Credentials

    ![Screenshot (968)](https://user-images.githubusercontent.com/65442845/118179633-29b5d600-b453-11eb-9e4d-70e22ed0d20b.png)
 
   -> In kind dropdown we have to select "SSH username with private key"

    ![Screenshot (969)](https://user-images.githubusercontent.com/65442845/118179752-52d66680-b453-11eb-9a01-fa1db97bcb7d.png)

   -> USER: we have to add the user created in slave node instance "jenkins-slave-01"
 
   -> PrivateKey
 
   -> Enter Directly 
 
   -> Paste the id_rsa key in the box
   
    ![Screenshot (970)](https://user-images.githubusercontent.com/65442845/118179872-79949d00-b453-11eb-8e78-61edef048f4f.png)
    
   -> You can get the key from below commands

```
    sudo su - jenkins-slave-01
    pwd
    /home/jenkins-slave-01
    cd .ssh
    more id_rsa
```
![S9](https://user-images.githubusercontent.com/65442845/118178890-30901900-b452-11eb-8c5e-d96f94f8eba8.PNG)

![S10](https://user-images.githubusercontent.com/65442845/118178949-443b7f80-b452-11eb-8755-d32c53633839.PNG)
   
   -> after pasting the private key click add button and add jenkins-slave-01

![Screenshot (971)](https://user-images.githubusercontent.com/65442845/118180039-b95b8480-b453-11eb-9329-ce8660a20628.png)

 * You will get this message on sucessfully connection of the node
    
    ![Screenshot (973)](https://user-images.githubusercontent.com/65442845/118180296-fde72000-b453-11eb-8c07-d59dfdaaa413.png)

 * We are using the Webhooks to integrate jenkins with github to trigger the automatically

 * Log into your github account
  
    -> Goto your project repository

    ![image](https://user-images.githubusercontent.com/65442845/118180621-5fa78a00-b454-11eb-9549-ae15e0869677.png)
    
    -> Look for settings on top right after insights then click settings
  
    -> Goto webhooks
  
    -> Add webhook

    ![image](https://user-images.githubusercontent.com/65442845/118180832-a39a8f00-b454-11eb-91e7-a804eb23f414.png)

 * Example: http://MASTERPULICIP:8080/github-webhook/

    -> content/type select
       Application/json

    -> Secret
        ***********
 
    -> Get secret code from jenkins dashboard

    -> Profile
 
    -> configure
    ![Screenshot (978)](https://user-images.githubusercontent.com/65442845/118181150-0a1fad00-b455-11eb-9b58-d42131215ae9.png)
    
    ![Screenshot (979)](https://user-images.githubusercontent.com/65442845/118181235-21f73100-b455-11eb-8f87-c4cb3d6c0518.png)
    
    ![Screenshot (980)](https://user-images.githubusercontent.com/65442845/118181255-27547b80-b455-11eb-8d1d-cafcf8be51ce.png)    
 
    -> API token generate
 
    -> copy that and past in weebhooks

* Comeback to jenkins portal and create a new job
 
    -> New item then give a name of the job and don't give space in job creation as here give later i have changed to sudhanshu
    
    ![Screenshot (982)](https://user-images.githubusercontent.com/65442845/118181503-78646f80-b455-11eb-92e2-6e59f7a3ecfe.png)
 
    -> select pipeline then ok
 
    -> In Build Triggers
 
    -> Select GitHub hook trigger for GITScm polling
    
    -> Then you have to write your own groovy script as per your needs
 
 ```
 pipeline {
    agent {
        label 'Java'
        
    }

    stages {
        stage('gitcheckout') {
            steps {
                git branch: 'main', url: 'https://github.com/2sudhanhu/Jenkins-Intergration-with-weebhooks.git'
            }
        }
        stage('pull'){
            steps {
                sh 'cd /var/www/html/Jenkins-Intergration-with-weebhooks/ && sudo git pull origin main'
            }
        }
    }
}
```
    
   -> after pasting the private key click add button

 ![Screenshot (983)](https://user-images.githubusercontent.com/65442845/118181663-a0ec6980-b455-11eb-8ae3-4b915f949adf.png)    

 * To check we done every configuration correct we have to push some code to github from local machine.
 * Use gitbash or any other tool got your project folder [here we are using testing folder]
    -> Create a new file name it (ex: file.txt) write some code then run below commands in gitbash
    -> git add file.txt
    -> git commit -m "write your message"
    -> push origin -u main
 * You can also change the Document root file to the configuration default it is 
   /var/www/html to /var/www/html/Jenkins-Intergration-with-weebhooks/ you will be get in the line 122 and the path of the file is given below
   i have changed my Document root file because i have clone the git in /var/www/html/ and the file name was Jenkins-Intergration-with-weebhooks you can also change to /home/jenkins-slave-01/workspace/sudhanshu screenshot attach for reference
   
   ![image](https://user-images.githubusercontent.com/65442845/118173849-b78dc300-b44b-11eb-8d13-fc28d88ee7ec.png)
   
   ![image](https://user-images.githubusercontent.com/65442845/118176277-d8a3e300-b44e-11eb-8589-713343410321.png)

   
### NOTE:   sudhanshu and "Sudhanshu JOB' are the job name which are highlighted in yellow but make sure don't put space in your JOB otherwise you have to create new job as i did.

```
    vi cd /etc/httpd/conf/httpd.conf
```
 * Goto jenkins Dashboard check it wheather the build is triggered or not.

 * Then in the browser Enter the ip of slave instance You will see the message you have given in the file.txt 

 * With this configuration of Jenkins Master and Slave Nodes on AWS environment and triggering jenkins job with github integration is complete. 

    ![image](https://user-images.githubusercontent.com/65442845/118181972-080a1e00-b456-11eb-9eed-f11b0a0b9d86.png)
    
    
    ![image](https://user-images.githubusercontent.com/65442845/118182046-28d27380-b456-11eb-8670-5c3f8ba637be.png)
    
    
### OUTPUT:
![image](https://user-images.githubusercontent.com/65442845/118184345-da72a400-b458-11eb-9691-e473d03633c1.png)





xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxEND OF FILExxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


**********
# References 
**********
```
  https://bhargavamin.com/how-to-do/setup-jenkins-slave-amazon-linux-aws/
  https://www.youtube.com/watch?v=hwrYURP4O2k

  https://medium.com/@mightywomble/jenkins-pipeline-beginners-guide-f3868f715ed9

  https://medium.com/edureka/jenkins-pipeline-tutorial-continuous-delivery-75a86936bc92#:~:text=Creating%20your%20first%20Jenkins%20pipeline.,pipeline%20or%20a%20scripted%20one

  https://www.codurance.com/publications/2019/05/21/creating-a-jenkinsfile-pipeline
```
***********************************************************************************************************************************************************************

## To install maven Commands and script
```
    #!/bin/bash
    sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
    sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
    sudo yum install -y apache-maven
    mvn –v
```    
 
 
