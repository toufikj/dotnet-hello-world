# Hello World .NET Core Application

# Run locally
```
dotnet run --project hello-world-api
```
Then launch your browser and access http://localhost:5000/api/hello

# Deploy to Cloud Foundry
```
cf push
```
Follow the console output to gather the url

# Jenkins Pipeline Setup & Environment Parameters

This project includes a Jenkins pipeline for automated build, Docker image creation, and deployment. The pipeline is defined in the `Jenkinsfile` and supports environment selection for UAT or Production.

## Jenkins Pipeline Setup

1. **Configure Jenkins:**
   - Install Docker on your Jenkins server.
   - Add your DockerHub credentials to Jenkins (ID: `dockerhub-creds`).
   - Create a new pipeline job and point it to this repository.

2. **Pipeline Parameters:**
   - The pipeline uses a parameter named `ENV` to select the deployment environment.
   - Choices: `UAT` or `PROD`.

3. **How to Run:**
   - When starting the pipeline, select the desired environment from the dropdown.
   - Example:
	 - For UAT: select `UAT` and start the build.
	 - For Production: select `PROD` and start the build.


