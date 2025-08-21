**Face-Recognition**
    ✨In this project, we will use the AWS Rekognition service to identify people.

**Detail about this project:**
    Here we are going to identify the see peoples using AWS Rekognition Service.
    
    Our first goal is to provide AWS Rekognition Services with several reference images of people so that it will create Faceprints of them.  While feeding the source image, we additionally communicate the person's metadata (user name) using Python script (upload-image-to-s3.py). The faceprints are then stored in a DynamoDB table, along with the username, for data durability.

    We developed and launched a Flask application on AWS EKS Cluster that allows users to upload photographs via the UI, which are then processed and compared to existing faceprints. If a match is found, the system obtains the relevant identity from a DynamoDB table and shows the name of the detected individual to the user.

🏠 **Architecture:**

<img width="1217" height="670" alt="image" src="https://github.com/user-attachments/assets/88e76ca7-5f0f-4b38-982f-933f6a478633" />


📃 **list of services:**
    1. S3 Bucket
    2. Lambda Function
    3. IAM Role
    4. DynamoDB Table
    5. VPC
    6. Security groups
    7. EC2 Instance
    8. EKS Cluster

✈️ **Now we are ready to deploy our application on cloud** ⛅

**Clone this repository to your local machine using** 🧐
     gitclone https://github.com/logesh81098/Face-Recognition
     Open **Face-Recognition** folder
     
Execute Terraform init to Initiate the Terraform
            terraform init      

Execute Terraform plan to check about infrastructure 

            terraform plan

Execute Terraform apply to build this infrasturcute

            terraform apply

✨Finally,type yes for prompt


Thank you so much for reading..😅

Happy learning !!!!!!! 😉😶‍🌫️
