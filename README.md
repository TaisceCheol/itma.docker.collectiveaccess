### ITMA Collective Access Dockerfile

In order to run Collective Access using Docker you will need to setup two Docker containers, one for mysql and the other an apache server running Collective Access.

Config:

If using docker-machine on mac, first create a VM and then configure shell:
```
docker-machine create docker.dev
docker-machine start docker.dev
eval $(docker-machine env docker.dev)

```
Having followed these steps typing `docker version` should return something similar to the following:
```
Client version: 1.6.0
Client API version: 1.18
Go version (client): go1.4.2
Git commit (client): 4749651
OS/Arch (client): darwin/amd64
Server version: 1.10.3
Server API version: 1.22
Go version (server): go1.5.3
Git commit (server): 20f81dd
OS/Arch (server): linux/amd64
```

Step 1: Setup mysql container

```
docker pull mysql

docker run -p 3900:3307 --name mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:latest

```

Step 2: Configure mysql

Log in to the mysql container and setup user and database for Collective Access. This can be done using mysql itself if installed or alternatively via Docker itself.

The username, password and database name used here should match those used in the collectiveaccess setup.php file.

```
docker exec -it mysql bash
mysql -uroot -p -P 3900
```

Enter password root at the prompt and then continue to create a user:
```
create user 'piaras.hoban@itma.ie'@'%' identified by '[password]';
grant all privileges on *.* to 'piaras.hoban@itma.ie'@'%' with grant option;
flush privileges;
```

Finally create the collective acccess database:

```
create database itma_ca;
show databases;
exit;
```

Step 3: Build the Collective Access Docker image
```
docker build --tag='collectiveaccess' .
```
Step 4: Launch Collective Access container and link to mysql container:

```
docker run -d -p 8080:80 --name ca --link mysql:mysql collectiveaccess 
```

If all went correctly running `docker ps` should display the two running containers.

Using the IP of the Docker VM `docker-machine ip docker.dev` navigate to  http://DOCKER_MACHINE_IP:8080/providence/install 
and you should be able to start the Collective Access install process.


I found this tutorial really helpful: http://jessesnet.com/development-notes/2015/docker-lamp-stack/


