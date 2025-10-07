# 3-tier-Architecture-Deployment-across-Multiple-Environments
This is a comprehensive DevOps project demonstrating the deployment of the YelpCamp(3-tier architecture) application across various environments. The project includes setting up a three-tier deployment process covering local, containerized, and Azure Kubernetes Service (AKS) environments.

## Introduction

YelpCamp is a full-stack web application designed for campground reviews. This project focuses on setting up a robust deployment pipeline for YelpCamp, ensuring reliability, scalability, and maintainability across different environments.
![113733448-1a3ac300-9718-11eb-9fc7-defb8d2cd9c1](https://github.com/user-attachments/assets/f680a1a0-c119-4e86-a961-ba0844673076)
![113733438-173fd280-9718-11eb-8a0d-8e13f1ab3d45](https://github.com/user-attachments/assets/846c0d1e-e36d-4325-ad32-596e81813486)
![113733465-1e66e080-9718-11eb-9ffe-8b047640942a](https://github.com/user-attachments/assets/7dce0b1e-3b14-4a82-99b2-4869184d2686)
![113734300-d8f6e300-9718-11eb-801e-5cb4698a1560](https://github.com/user-attachments/assets/ab182441-becf-48f2-a5f1-411f557985a3)


## Features

- **Local Deployment:** Allows developers to test the application locally before pushing changes to other environments.
- **Container Deployment:** Utilizes Docker containers for development and testing, incorporating Jenkins pipelines for automated builds, tests, and scans.
- **Azure AKS Deployment:** Automates deployment to Azure Kubernetes Service (AKS) for production-level environments, ensuring seamless scalability and reliability.

## Architecture
![3-tier-deployment drawio (1)](https://github.com/user-attachments/assets/57e04ae0-7179-481f-a0fb-632e85f8d6c1)


## Project Structure
> **src** contains source code of yelpcamp including Dockerfile, Manifests file.

> **Terraform** consist instrastructure modular code. 

> **scripts** consist scripts to install tools on specific machine to reduce manual intervention.

## Tools and Technologies

- **Docker:** Containerization platform used for packaging the application and its dependencies.
- **Jenkins:** Automation server used for setting up continuous integration and continuous deployment (CI/CD) pipelines.
- **GitHub:** Version control system used for managing project source code and collaboration.
- **Terraform:** Infrastructure as code (IaC) tool used for provisioning and managing cloud infrastructure.
  > Modularized Code  |  Utilized workspace 
- **SonarQube:** Open-source platform for static code analysis to detect bugs, vulnerabilities, and code smells.
- **Trivy:** Vulnerability scanner for containers and other artifacts, used for scanning Docker images.

## Steps to Replicate the Project

### 1. **Project Setup**

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/vsingh55/3-tier-Architecture-Deployment-across-Multiple-Environments.git
   cd 3-tier-Architecture-Deployment-across-Multiple-Environments
   ```

2. **Put the values of environment variable and change .auto.tfvars files.**

### 2. **Infrastructure Provisioning**

1. **Install Required Tools:**
   - Terraform
   - kubectl
   - Azure CLI

2. **Initialize and Apply Terraform:**
   ```bash
   cd Terraform
   terraform init
   terraform workspace new dev
   terraform workspace select dev
   terraform apply -var-file=dev.auto.tfvars
   ```

### 3. **Set Up Jenkins Pipeline**

1. **Install Jenkins and Necessary Plugins.** 
( May Refer the [Blog](https://blogs.vijaysingh.cloud/unlocking-jenkins) )

2. **Add Credentials for Docker Hub, SonarQube, and Kubernetes in Jenkins.**

3. **Create Jenkins Pipeline Job:**
   - Use the `Jenkinsfile` from the repository.

### 4. **Application Deployment**

1. **Prepare Kubernetes Manifests in the `Manifests` directory.**

2. **Create Namespace in AKS:**
   ```bash
   kubectl create namespace webapps
   ```

3. **Run Jenkins Pipeline to Deploy Docker Image to AKS.**



### 8. **Cleanup**

1. **Destroy Infrastructure:**
   ```bash
   terraform destroy -var-file=<name_of_environment>.auto.tfvars
   ```

2. **Remove Unused Resources.**


---

<!-- ## Skills Gained

By working on the this project, you will gain valuable experience in:

- Setting up CI/CD pipelines using Jenkins.
- Containerizing applications with Docker.
- Conducting static code analysis and vulnerability scanning.
- Deploying applications to Azure Kubernetes Service (AKS).
- Infrastructure as code (IaC) using Terraform. -->


## Blog 🖥️

Check out the Blog below for detailed desscription of this project: [**click here**](https://blogs.vijaysingh.cloud/deploy-trio)

## Contribution

Contributions to the this project are **Welcome!** If you encounter any issues or have suggestions for improvement, feel free to open an issue or submit a pull request.

## Acknowledgements

- This project was inspired by the need for a robust deployment pipeline for YelpCamp.
- Special thanks to the contributors and maintainers of the tools and technologies used in this project.
- Media management provided by **Cloudinary**.
- Maps integration provided by **Mapbox**.
---