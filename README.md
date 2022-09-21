# RedAcre

Extract both the folder to your pc **redacre-docker-compose** as well as **redacre-Terraform

### Step 1 - Dockerize the Application
- In order to use this aplication you must have docker installed on your computer.
- To run this aplication you must run **"docker-compose up --build"** command to access the aplication you should reach http://localhost/ or http://127.0.0.1:80

### Step 2 - Deploy on Cloud
- In order to deploy this application on AWS set the AWS credentials.
- Use the following commands
- **terraform init**
- **teraform plan**
- **teraform apply**

### Step 3 - Get it to work with Kubernetes
- In order to work with Kubernetes enter the given command.
- **kubectl apply -f sys-stats.yaml**
