# build the docker image

docker build -f Dockerfile-ubuntu18 -t ubuntu:18.04


# run docker container

docker run -it ubuntu:18.04
