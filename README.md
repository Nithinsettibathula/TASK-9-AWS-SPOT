# 🚀 Strapi CMS: Enterprise Deployment on AWS ECS Fargate Spot
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)
![AWS](https://img.shields.io/badge/AWS-ECS%20Fargate-orange?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/IaC-Terraform-blueviolet?logo=terraform)
![Docker](https://img.shields.io/badge/Container-Docker-blue?logo=docker)

## 🌟 Executive Summary
As a **DevOps Intern** at **Pearl Thoughts**, I successfully architected and deployed a containerized Strapi application using a fully automated CI/CD pipeline. This project demonstrates advanced orchestration using **AWS ECS**, cost-optimization via **Fargate Spot**, and Infrastructure as Code using **Terraform**.


- **Name:** Nithin Settibathula
---

## 🏗️ Technical Architecture
The deployment utilizes a robust cloud-native architecture:

1. **Source Control:** GitHub acts as the single source of truth.
2. **CI/CD:** GitHub Actions automates the build and deployment process.
3. **Container Registry:** Docker images are stored in **Amazon ECR**.
4. **Orchestration:** **AWS ECS** manages the lifecycle of the Strapi containers.
5. **Cost Logic:** Infrastructure runs on **Fargate Spot** to minimize operational expenses.

---

## ⚡ Key Features & Achievements

- **Automated Infrastructure:** Zero manual configuration; 100% Terraform-managed resources.
- **Cost Efficiency:** Implemented **Fargate Spot** capacity providers for significant cost savings.
- **Environment Security:** Securely handled Strapi secrets and database keys during the Docker build process.
- **Scalable Design:** Defined tasks with 1GB RAM and 0.5 vCPU to balance performance and cost.
- **Network Security:** Custom Security Groups configured to expose only the necessary application port (1337).

---

## 📂 Project Structure
```text
.
├── .github/workflows/   # CI/CD Pipeline (GitHub Actions)
├── strapi-app/          # Strapi Source Code & Dockerfile
├── main.tf              # Terraform Infrastructure Definitions
└── README.md            # Project Documentation
