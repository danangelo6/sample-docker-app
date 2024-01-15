## CI Folder

CI folder is used as a staging folder where we get all sensitive configurations from Parameter Store/SSM/S3. Each file on this folder will be called on the Docker file to be copied on their specific locations

# Docker

For POC we created 2 docker file. the first docker file `dockerfile.debian` this will create a PHP container with composer and PHP extensions ONLY and be stored on our private Docker Repository. The created image will then be used by the second docker file `dockerfile.application`. This docker file will copy all application code and its configuration secrets.

The benefit of using 2 docker file is that the it will help speed up build time of the 2nd docker file, since it will call the pre build docker file 1 and copy all codes. The first docker file `dockerfile.debian` will be only build once there are updates on PHP version and PHP extensions.

# Setting up the container

1. Clone the repository and make sure you have Docker installed
2. Go to the home directory of the project and build the docker file
    * For local development you cannot build the `dockerfile.debian` since SBC Firewall blocks the downloading of debian packages
    * You can proceed with the building of the 2nd docker file `dockerfile.application`, since the first docker file is already build and hosted on hub.docker.com
    * Run this command `docker build -t <APPLICATION_NAME> -f dockerfile.application . `
3. Once the docker image has been created you can verify it on the command line using this command `docker image ls`
4. Build the container using the image that has been recently created
    * Run this command `docker run -p 8080:80 <APPLICATION_NAME> `
    * you can change the specific port by changing the first part of the port command `<$PORT>:80`
5. Test your container by logging in to localhost:8080