# 🚀 CRUD Operations in Amazon DynamoDB using AWS Lambda & Terraform

A serverless AWS project demonstrating Create, Read, Update, and Delete (CRUD) operations in Amazon DynamoDB using AWS Lambda, Python, and Terraform. This project focuses on infrastructure automation, secure AWS permissions, and efficient serverless application development.

## 📌 Project Overview

This project demonstrates how to build a serverless application that performs CRUD operations on Amazon DynamoDB using an AWS Lambda function.

Terraform is used to automate infrastructure provisioning, reducing manual configuration and making deployments repeatable.

### 🎯 Project Objectives

- Implement Create, Read, Update, and Delete operations.
- Use AWS Lambda to execute Python application logic.
- Store and manage data in Amazon DynamoDB.
- Automate AWS infrastructure provisioning using Terraform.
- Configure IAM permissions following the principle of least privilege.
- Test Lambda functionality using AWS Lambda test events.

## 🏗️ Architecture Diagram

```text
                 ┌──────────────────────┐
                 │       Developer      │
                 │  Terraform Commands  │
                 └──────────┬───────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │      Terraform       │
                 │ Infrastructure as    │
                 │        Code           │
                 └──────────┬───────────┘
                            │ Provisions
                            ▼
             ┌──────────────────────────────┐
             │           AWS Cloud          │
             │                              │
             │   ┌──────────────────────┐   │
             │   │     AWS Lambda       │   │
             │   │   Python Function    │   │
             │   └──────────┬───────────┘   │
             │              │               │
             │              │ CRUD Requests │
             │              ▼               │
             │   ┌──────────────────────┐   │
             │   │    Amazon DynamoDB   │   │
             │   │     NoSQL Database   │   │
             │   └──────────────────────┘   │
             │                              │
             │   IAM Execution Role         │
             │   CloudWatch Logs            │
             └──────────────────────────────┘
```

### 🔄 Architecture Workflow

1. Terraform defines and provisions the required AWS infrastructure.
2. AWS Lambda executes the Python application code.
3. Lambda uses the AWS SDK for Python (Boto3) to interact with DynamoDB.
4. IAM permissions control which database operations Lambda can perform.
5. DynamoDB stores and retrieves application data.
6. Lambda returns the operation result, while CloudWatch can be used to inspect execution logs.

## ☁️ AWS Services & Technologies Used

| Technology | Purpose |
|---|---|
| Amazon DynamoDB | NoSQL database for storing application data |
| AWS Lambda | Serverless execution of Python code |
| AWS IAM | Secure access control and execution permissions |
| Amazon CloudWatch | Lambda execution logs and troubleshooting |
| Terraform | Infrastructure provisioning and automation |
| Python | Application logic |
| Boto3 | Python SDK for AWS services |
| Git & GitHub | Version control and project documentation |

## ✨ Key Features

- **Create:** Insert new records into DynamoDB.
- **Read:** Retrieve existing records from the database.
- **Update:** Modify existing database items.
- **Delete:** Remove records from DynamoDB.
- **Infrastructure as Code:** Define AWS resources using Terraform.
- **Serverless Execution:** Run application logic without managing servers.
- **IAM Least Privilege:** Grant only the permissions required by the Lambda function.
- **Logging and Debugging:** Use CloudWatch logs to investigate execution issues.

## 🗄️ Amazon DynamoDB

Amazon DynamoDB is a fully managed NoSQL database designed for applications requiring scalable and low-latency data access.

In this project, DynamoDB acts as the backend database for the Lambda function.

The table's name, partition key, and attribute structure should match the Terraform configuration and Python code in this repository.

## ⚡ AWS Lambda

AWS Lambda runs the Python function that processes database operations.

The function uses Boto3 to communicate with DynamoDB and performs the requested operation based on the incoming event.

### Responsibilities

- Process incoming test events.
- Validate the requested operation and required attributes.
- Execute DynamoDB API calls.
- Return suitable responses.
- Log execution details for troubleshooting.

## 🔐 IAM Security

The Lambda function uses an IAM execution role to access the required AWS resources.

The permissions should be scoped to the relevant DynamoDB table rather than granting unrestricted access to all AWS resources.

Depending on the operations implemented, the policy may require permissions such as:

- `dynamodb:PutItem`
- `dynamodb:GetItem`
- `dynamodb:UpdateItem`
- `dynamodb:DeleteItem`
- `dynamodb:Scan` — only if scanning is implemented.

CloudWatch logging permissions may also be required.

**Security best practices followed:**

- Apply the principle of least privilege.
- Avoid hardcoding AWS access keys in application code.
- Restrict DynamoDB permissions to the required table.
- Keep Terraform state and sensitive configuration files protected.
- Never commit AWS credentials or secrets to GitHub.

## 🛠️ Prerequisites

Before deploying this project, ensure you have:

- An AWS account with the required permissions.
- Terraform installed.
- AWS CLI installed and configured.
- Python installed for local development, if required.
- Git installed.
- Access to the project's Terraform configuration and Lambda source code.

Verify your installations:

```bash
terraform -version
aws --version
python --version
git --version
```

Verify your AWS identity:

```bash
aws sts get-caller-identity
```

Configure AWS credentials using an appropriate AWS CLI profile or another supported credential provider.

## 🚀 Deployment Guide

### Step 1: Clone the Repository

```bash
git clone https://github.com/VishalKonde01/crud-in-dynamodb-using-lambda-with-terraform.git
```

Navigate to the repository:

```bash
cd crud-in-dynamodb-using-lambda-with-terraform
```

### Step 2: Initialize Terraform

Run this command from the directory containing the Terraform root configuration:

```bash
terraform init
```

This initializes the Terraform working directory and downloads the required providers.

### Step 3: Validate the Configuration

```bash
terraform validate
```

This checks whether the Terraform configuration is syntactically valid and internally consistent.

### Step 4: Review the Execution Plan

```bash
terraform plan
```

Review the proposed infrastructure changes before deployment. Confirm the AWS region, resource names, IAM permissions, and potential costs.

### Step 5: Deploy the Infrastructure

```bash
terraform apply
```

Review the plan and type `yes` when prompted.

Terraform will create or update the resources defined in your configuration.

**Note:** If your Terraform configuration is inside a subdirectory, run these commands from that directory. Adjust the instructions to match your repository's actual file structure and variables.

## 🧪 Testing CRUD Operations

After deployment, open the AWS Lambda console and select the deployed function. Use Lambda test events that match the event format expected by your Python handler.

Test each supported operation separately.

### 1. Create

Insert a new record into DynamoDB.

Example event format:

```json
{
  "action": "create",
  "user_id": "101",
  "name": "Sample User",
  "email": "sample@example.com"
}
```

Expected result: The record is inserted successfully when the event matches the handler's expected format and required attributes.

### 2. Read

Retrieve an existing record.

```json
{
  "action": "read",
  "user_id": "101"
}
```

Expected result: The Lambda function retrieves the matching item, if it exists.

### 3. Update

Modify an existing record.

```json
{
  "action": "update",
  "user_id": "101",
  "name": "Updated User"
}
```

Expected result: The requested attribute is updated according to the Lambda implementation.

### 4. Delete

Delete an existing record.

```json
{
  "action": "delete",
  "user_id": "101"
}
```

Expected result: The matching record is deleted if it exists.

**Important:** These are illustrative event examples. The action names, partition key, required attributes, and payload structure must match your actual Lambda function. The expected responses depend on the implementation.

### Verify the Results

After each test:

1. Open the Amazon DynamoDB console.
2. Select the table configured for the project.
3. Open the table's item explorer.
4. Confirm that the create, read, update, or delete operation produced the expected result.
5. Review the Lambda execution logs in CloudWatch if an error occurs.

## 🐛 Troubleshooting

| Issue | What to check |
|---|---|
| Terraform initialization fails | Provider configuration, internet access, and Terraform version |
| AWS access denied | AWS credentials, IAM permissions, and resource policies |
| Lambda cannot access DynamoDB | Execution role and table ARN |
| DynamoDB validation error | Partition key and required attributes |
| Lambda returns an error | Test event format and CloudWatch logs |
| Decimal serialization error | Convert DynamoDB `Decimal` values into JSON-compatible values before serialization |
| Terraform state or backend error | Backend configuration, bucket access, and state file location |

## 💰 Cost Optimization

This project demonstrates how serverless services can reduce infrastructure management overhead.

Potential cost benefits include:

- No continuously running application server is required.
- Lambda charges depend on the applicable invocation and compute pricing.
- DynamoDB on-demand capacity can be suitable for workloads with variable traffic.
- Infrastructure can be removed when it is no longer needed.

Actual costs depend on usage, AWS region, database capacity settings, logging, and other resources. Always review the AWS pricing model before deployment.

## 🧹 Clean Up Resources

After testing, remove the infrastructure created by Terraform if you no longer need it.

Run the following command from the Terraform root directory:

```bash
terraform destroy
```

Review the proposed deletions and confirm when prompted.

**Warning:** Destroying resources may permanently delete data stored in the DynamoDB table. Back up any important data before proceeding, and verify that the Terraform configuration does not manage resources you want to keep.

## 📚 Key Learning Outcomes

Through this project, I strengthened my understanding of:

- Serverless architecture using AWS Lambda and DynamoDB.
- Implementing CRUD operations with Python and Boto3.
- Provisioning AWS resources through Terraform.
- Configuring IAM execution roles and least-privilege permissions.
- Testing Lambda functions with custom test events.
- Troubleshooting AWS service integration errors.
- Using CloudWatch logs to investigate application failures.
- Managing cloud infrastructure through Infrastructure as Code.



## ✅ Conclusion

This project demonstrates how AWS Lambda, Amazon DynamoDB, IAM, and Terraform can work together to build a serverless application with automated infrastructure provisioning.

It provides hands-on experience with cloud automation, database operations, access control, and serverless application development — important skills for cloud engineering and DevOps roles.

## 👨‍💻 Author

**Vishal Konde**

- GitHub: [VishalKonde01](https://github.com/VishalKonde01)


---

⭐ If you find this project useful, feel free to explore the repository and share your feedback.

