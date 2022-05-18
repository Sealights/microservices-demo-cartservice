$ bash file
docker build -t microservices-demo-cartservice .
docker tag microservices-demo-cartservice:latest 159616352881.dkr.ecr.eu-west-1.amazonaws.com/microservices-demo-cartservice:latest
docker push 159616352881.dkr.ecr.eu-west-1.amazonaws.com/microservices-demo-cartservice:latest