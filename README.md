## A Purpose

This collection of files shows how AWS CloudFormation Conditionals can be used to create a sort of generic template.  Specifically, this method allows a developer to add an arbitrary number of containers to a service in an ECS Cluster, the details of which can all be specified inside of a properties file.

Before using this CloudFormation template, the primary structure of your AWS Stack should be created and running already, including things like your EC2 instance, VPC, ALB, and ECS instance.  The prupose of this CloudFormation template is only to customize and/or add containers which are attached to a given service in an ECS instance in an automated and convenient way.

## File Information

- **deployment.properties** -> All of the general information associated with your AWS stack, as well as all specifications for the containers you want to deploy to the service.  The work flow I currently have set up allows up to five different containers, so each specification is a list of values.  All 5 values in the list must be filled in.  If a value is not needed, **null** is used for a no-value string and **-1** is used for a no-value integer.
- **launch-template-service.sh** -> This is the shell script which is run to either create or update a stack using the CloudFormation template.  The script reads in the CLI profile from the user.  The script must be run with either `--create` or `--update` depending upon what you want to do.
- **template-environment-service.yml** -> This is the CloudFormation template itself which is synced with S3 in the above deployment script.  The template is customized to utilize up to 5 different containers in a given service for a pre-existing AWS Stack.

A more detailed write-up of this project can be found [here](https://jjgccg.github.io/projects/multicontainer-cloudformation).
