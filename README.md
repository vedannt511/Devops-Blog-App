
# Java Blogging Application - AWS EKS Deployment

## Overview
This project is a Java-based blogging application designed for scalable and high-performance blog management. It supports CRUD operations for blog posts, user authentication, and comment management. The application is containerized using Docker and deployed on an AWS Elastic Kubernetes Service (EKS) cluster.  

For continuous integration and deployment (CI/CD), a Jenkins pipeline automates the entire build, test, analysis, and deployment process.

---

## Architecture
**Tech Stack:**
- Backend: Java (Spring Boot)
- Build Tool: Maven
- Containerization: Docker
- Orchestration: Kubernetes (AWS EKS)
- CI/CD: Jenkins
- Code Quality: SonarQube
- Security Scan: Trivy
- Artifact Repository: Nexus
- Container Registry: DockerHub

---
## Prerequisites

Before deploying this application, make sure you have the following tools installed and properly configured:

- **Git**: Version control system for source code management.
- **Docker**: To build and run containers locally, and for testing Docker images before deployment.
- **kubectl**: Kubernetes command-line tool, configured for your AWS EKS cluster.
- **AWS CLI**: Configured with necessary IAM permissions for EKS, EC2, VPC, and network resources. Ensure your credentials are valid and have raised service quotas as needed.
- **Terraform** : For infrastructure provisioning. Terraform should be version 1.3 or higher. 
- **Prometheus & Grafana**: Monitoring and dashboard tools for Kubernetes clusters and application metrics, typically deployed via Helm.
- **Jenkins** (or another CI/CD tool): For automated pipeline runs and integration steps (building, testing, deploying).
- **AWS IAM Authenticator**: For authenticating via Kubernetes RBAC on AWS EKS.



## Project Structure
```
.
Devops-Blog-App/
├── src/
│ ├── main/
│ │ ├── java/com/blog/app/
│ │ └── resources/
│ │ └── application.properties
│ └── test/
│ └── java/com/blog/app/
├── deployment/
│ ├── deployment.yml
│ ├── service.yml
│ └── ingress.yml (if applicable)
├── Dockerfile
├── Jenkinsfile
├── terraform/
│ ├── .terraform.lock.hcl
│ ├── eks.tf
│ ├── iam.tf
│ ├── networking.tf
│ ├── outputs.tf
│ ├── provider.tf
│ ├── security.tf
│ ├── terraform.tfstate
│ ├── terraform.tfstate.backup
│ ├── tplan
│ ├── variables.tf
│ ├── versions.tf
├── pom.xml
├── .gitignore
└── README.md
```

---

## Terraform Infrastructure Modules

Within the `terraform/` directory, infrastructure is defined using modular, clear files:

- **provider.tf/versions.tf**: Provider and required Terraform version settings
- **networking.tf**: VPC, subnets, and networking resources for EKS
- **security.tf**: Security groups, IAM policies
- **iam.tf**: IAM roles for EKS cluster and worker nodes
- **eks.tf**: EKS cluster and node group resources
- **outputs.tf**: Output variables (kubeconfig, endpoints)
- **variables.tf**: Configurable variables (region, cluster name, etc.)
- **tplan**: Terraform plan output or planfile

---

### Terraform Usage

1. **Install Terraform** and ensure AWS CLI is configured.
2. **Initialize** in the `terraform/` directory:
```
cd terraform
terraform init
```

3. **Plan** and **apply** your infrastructure:
```
terraform plan -out tplan
terraform apply "tplan"
```
---

## Jenkins Pipeline Stages

The CI/CD pipeline automates development and deployment through the following stages:

1. Git Checkout  
   Fetches the latest source code from the repository.

2. Compile  
   Builds the Java project using Maven.

3. Unit Test  
   Runs all unit tests to verify core functionality.

4. Trivy Scan  
   Performs a security vulnerability scan on the Docker image.

5. SonarQube Analysis  
   Performs static code analysis for code quality and maintainability.

6. Quality Gate Check  
   Ensures that the build passes the configured quality gate in SonarQube.

7. Build JAR  
   Packages the project into a JAR file.

8. Deploy to Nexus  
   Uploads the generated artifact to the Nexus repository.

9. Docker Image Build  
   Builds a Docker image using the Dockerfile.

10. Push to DockerHub  
    Pushes the built Docker image to DockerHub.

11. Deploy to Kubernetes (AWS EKS)  
    Deploys the application using Kubernetes manifests on the EKS cluster.

12. Verify Deployment  
    Confirms that all Kubernetes resources (pods, services, deployments) are successfully running.

---

## Deployment Instructions

### Prerequisites
- AWS CLI configured with EKS access.
- `kubectl` configured for your EKS cluster.
- Jenkins installed and configured.
- Docker installed locally or available through Jenkins agents.
- SonarQube server configuration.
- Nexus repository configured and credentials added to Jenkins.
- DockerHub credentials stored in Jenkins credentials manager.

### Steps
1. Clone the repository:
   ```
   git clone https://github.com/your-username/java-blog-app.git
   cd java-blog-app
   ```

2. Build and test locally (optional):
   ```
   mvn clean install
   ```

3. Open Jenkins and run the configured pipeline job.  
   The pipeline will:
   - Pull the code
   - Build and test the application
   - Analyze the code and perform a security scan
   - Build and push the Docker image
   - Deploy to AWS EKS

4. Verify the deployment:
   ```
   kubectl get pods
   kubectl get svc
   ```

---

## Docker Configuration
The Dockerfile defines the steps to containerize the application.

**Example:**
```
FROM eclipse-temurin:17-jdk-alpine
EXPOSE 8080
ENV APP_HOME /usr/src/app
WORKDIR $APP_HOME
COPY target/twitter-app-0.0.3.jar $APP_HOME/app.jar
ENTRYPOINT ["java","-jar","/usr/src/app/app.jar"]
```
To run locally
```
docker build -t blogapp .
```
---

## Kubernetes Deployment Files

### deployment-service.yml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bloggingapp-deployment
spec:
  selector:
    matchLabels:
      app: bloggingapp
  replicas: 2
  template:
    metadata:
      labels:
        app: bloggingapp
    spec:
      containers:
        - name: bloggingapp
          image: vedant511/blogapp:latest # Updated image to private DockerHub image
          imagePullPolicy: Always
          ports:
            - containerPort: 8080
      imagePullSecrets:
        - name: regcred # Reference to the Docker registry secret
---
apiVersion: v1
kind: Service
metadata:
  name: bloggingapp-ssvc
spec:
  selector:
    app: bloggingapp
  ports:
    - protocol: "TCP"
      port: 80
      targetPort: 8080 
  type: LoadBalancer
```



---

## Monitoring and Logging
For observability:
- Used AWS CloudWatch for centralized logging.
- Integrated Prometheus and Grafana for real-time metrics visualization.


---

