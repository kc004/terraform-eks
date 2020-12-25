# terraform-eks

### Prerequisites
```
terraform~>0.13.4, aws cli-v2, aws-authenticator (if older version of aws cli-v2) 
```
Upload docker images of web1 and web2 app to private repository.
```
$ docker tag web1:latest ecr.amazonaws.com/REPO:tag
$ docker push ecr.amazonaws.com/REPO:tag
```
### Deployment

Clone the source locally:

```
$ git clone https://github.com/kc004/terraform-eks.git
$ cd terraform-eks
```

Now, execute following command to run terraform file.
```
$ terraform init
$ terraform plan
$ terraform apply
```
It will take some time to create eks cluster,vpc,deploy sample applicaion and run script.\
Script contains installation of kubectl, HELM, Kompose and consul in kubernetes. </br>  I will use 'Kompose' tool to convert docker-compose file into kubernetes YAML formate files or HELM charts.\
Please make a new folder where kompose will automatically convert docker-compose file into kubernetes execution files.
```
cd New_Folder
kompose convert --file "/path/of/docker-compose"
```
If you want HELM charts then exectute this command
```
kompose convert -c --file "/path/of/docker-compose"
```
Now just need to run
```
kubectl create -f .
```
It will deploy whole application.

### Testing
```
$ kubectl get pods
$ kubectl get svc
```
Check load-balancer IP/domain in browser to test.

### Consul Service discovery and Mesh in kubernetes:
Add this annotation in all deployment where we want to activate sidecar
```
'consul.hashicorp.com/connect-inject': 'true'
```
Now it will create two sidecars: sync and envoy proxy

The below command shows how Consul resolves the order microservice endpoint.
```
dig @127.0.0.1 -p 8600 web1.service.consul SRV
```

For upstream and downstram service:
```
web1 and web2 depends upon redis so they are downstream from the redis service.
redis service is upstream for web1 and web2 becuase they are dependent on it.
```
add this annotation in web1/web2 deployment
```
'consul.hashicorp.com/connect-service-upstreams': 'redis:6380'
```
Now redis is registred with catelog and it is available at 'localhost:6380' in the web1/web2.\
When web1/web2 make request to redis it will established mTLS connection through sidecar.
