# Rusty-Lambda-Quick-Start
A simple set of scripts for generating scaffolding for AWS Lambda Functions.

# Scripting
The script in this folder will generate the scaffolding for a Rust Lambda function that is ready to be compiled for aarch64.

The scaffolding includes:
* an edit to the Cargo.toml that will aid compiling
* a script to compile the code for aarch64
* a script to create a new lambda function with the name you supply in the first argument
* a script to update that lambda function using the name that you supply in the first argument
* a folder for your modules with the name that you supply in the optional second argument

## Dependencies
* Rust/rustup
* Cargo Lambda
* Docker
* Cross
* AWS CLI
* aarch64-unknown-linux-musl toolchain for rustup

## Preparing to call the script for the first time
* Ensure that you have the dependencies installed. Feel free to ask Chat GPT for assistance.
* Make sure it's executable with `sudo chmod +x ./create_lambda.sh`
* Configure the AWS CLI
* Create an IAM Role for the lambda function(s)
* Copy the arn for that IAM Role and insert it into line 75 of `create_lambda.sh`
* Once you are ready, place this scripting folder in the folder you want your Rust functions to be in.

### If you are not using WSL:
You will probably need to comment out line 57 of `create_lambda.sh`, and then uncomment line 59.

## Calling the script
Navigate to this folder and call it with `./create_lambda.sh "your_lambda_name" "your_modules_folder_name"`

The modules folder name is optional.

This script will go to its folder's parent folder and create a directory called "your_lambda_name" that contains the scaffolding.

## Building your lambda function
All you gotta do is call `./build.sh`, 

## Deploying your lambda function
All you gotta do is call `./deploy.sh`, but you have to configure the AWS CLI prior to using it. Also, be sure to set the Lambda's IAM Role on line 75 of `create_lambda.sh`.

If there's a vim output showing up after calling this script, you can close it with `q`.

## Updating your lambda function
All you gotta do is call `./update_func.sh`

If there's a vim output showing up after calling this script, you can close it with `q`.
