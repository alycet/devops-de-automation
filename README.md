# DevOps Data Engineering Automation

## 📋 Table of Contents
- [Introduction]()
- [System Architecture]()
- [About the Data]()
- [Technologies Used]()
- [Packages]()
- [Project Execution Flow]()


## ⚡ Introduction

**Automate everything. Break nothing.**  
This project is a one-stop shop for spinning up cloud infrastructure and automating data workflows—*with zero manual intervention*. Designed for data engineers and DevOps pros, it combines **Terraform**, **GitHub Actions**, and **Python** to create an end-to-end automation pipeline that is secure, scalable, and fully testable.

Whether you're provisioning cloud resources or running data pipelines, this repo gives you the tools to do it right—every single time.

Project Features:

- **Infrastructure Provisioning**: Provision and deployment of infrastructure including S3 bucket, IAM role, Glue Crawler, and Glue Catalog.
- **Data Generation**: Python-based scripts for generating sample customer data.
- **Security Scanning**: Integrated with Bandit for static code analysis.
- **Automated Testing**: Code and data quality testing using Pytest
- **CI/CD Pipelines**: Building, testing, and deployment, automated with GitHub Actions.



## ⚙️ System Architecture
![Architecture Diagram]()

## 📊 About the Data
This script creates a synthetic dataset of customer records using the Faker library. It generates a CSV file containing randomized customer data, including:

- Timestamps within the past year
- Customer IDs
- First and last names
- Email addresses
- Street addresses, cities, and states

By default, it generates 10,000 records and saves them to `data/customer_data.csv`, simulating a realistic dataset for testing ETL workflows.

## 🧩 Technologies Used

- **Terraform**: Infrastructure as Code (IaC)
- **GitHub Actions**: Continuous Integration / Continuous Deployment
- **Python**: Scripting for data workflows
- **Bandit**: Security vulnerability scanner for Python
- **Pytest**: For running unit tests


## 📦 Packages
```
colorama==0.4.6
Faker==37.1.0
iniconfig==2.1.0
packaging==24.2
pluggy==1.5.0
pytest==8.3.5
tzdata==2025.2
boto3==1.28.62
moto==4.2.6
pytest-cov==4.1.0
urllib3<2.0.0
```

## 🔄 Project Execution

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Python 3.9+](https://www.python.org/downloads/)
- [pip](https://pip.pypa.io/en/stable/installation/)


### Clone the repository

```bash
git clone https://github.com/alycet/devops-de-automation.git
cd devops-de-automation
```

### Install the Dependencies

```bash
pip install -r requirements.txt
```

### Generate Test Data
A python script generates the test data for this pipeline. The script is located in the `scripts/` directory and creates a `customer_data.csv` file in the `data/` directory.
```bash
python scripts/generate_sample_data.py
```

### Run Unit Test
In order to ensure the quality of the sample data that is generated, unit test are perfomed using pytest. Tests are located in in the `test/` directory.
```bash
pytest test/test_generate_sample_data.py -v
```
Note: Since our `generate_sample_data.py` script is located in a differenct directory you many need to set environmental varaialble
```bash
PYTHONPATH=.
```
### Run Security Checks
Bandit is used as the security linter for the python code. The configuration for bandit is found in the `bandit.yaml` file.

```bash
bandit -r . -c bandit.yaml
```

### Initialize Terraform
This step sets up your Terraform environment, initializes required plugins, and shows a preview of infrastructure changes. After review, the apply command provisions the defined AWS resources.
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### CI/CD Pipeline
The Github Actions workflows are defined in the `.github/workflows/` diretory. 
The `deploy.yaml` file within the directory is triggered to execute with the following configuration:
```
on:
    pull_request:
        branches: [main]
    push:
        branches: [dev, main]
```
After the workflow is triggerd, the following steps are executed.
- Linting
- Security scanning
- Testing
- Terraform validation
- Terraform planning
- Deployment to production evnironment

