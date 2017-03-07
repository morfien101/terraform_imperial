This will contain the demo files for a Demo / Talk I am giving on the terraform runner, Terraform and AWS.

### Do Not Checkout Master ###

# How to use this repo.
This repo is to be used as part of a learning exercise that I will be teaching.
The tags on this repo represent steps that are taken during the building of this infrastructure.

Each tag builds onto the next and are numbered.
The tags can be seen above by clicking on the branch button and then the tags heading.

To checkout a tag use:

```shell
git clone --branch starting_skeleton https://github.com/morfien101/terraform_imperial.git
```

The above checkout statement is what we use to get started with the exercises.

# How to use these examples.
This repo builds its foundation with the work that has been completed in the terraform runner repo.
See below for links to the repo.
Take a look at that repo if you want to know more about how we are running terraform.

There is a vagrant file and a launch container file built into the repo.

To best use this repo I would recommend using the vagrant machine and Docker container that will be launched in the vagrant machine.
This will give you a consistent environment to work with.

If you are running on windows you will need to make sure that you have an SSH Client installed that you can use with Vagrant. Git-Bash (https://git-scm.com/download/win) supplies a good version of ssh that works on windows. Make sure that you select the option to add git to your PATH variable. You may have to restart to make windows update this variable.

If you are using a MAC or Linux you will need to set execute permissions on the launch container file.

Once you are setup you can clone this repo on on what ever branch you want to try. Then use the command "**vagrant up**" in your favourite shell to create the Vagrant machine. If your SSH client is in your path you can then use **vagrant ssh** to connect to the vagrant machine.

Inside the vagrant machine will be a container it will need to be downloaded if you are connecting for the first time since the creation of the vagrant machine.

Use the command
```shell
# Layout
./terraform-runner -c <json config file path> -a <action>

# Example
./terraform-runner -c scripts/config_files/aws_asg_ws.json -a apply
```

Some of the scripts will require you to add in environment variables so please read the code in the config_files directories. You will also need to add in your AWS Credentials before running the commands for the first time. You will need to do this for each login session you have. Below is an example of how to do this.
These examples require that you have an S3 bucket created and a SSH Key in the region that you are working in (__"us-east-1"__ in my examples).
These can be created in the AWS Console. The values are then used below.
```
# Create a SSH Key
http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
# Create a S3 bucket
http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html
```

```
# Inside the container
export AWS_ACCESS_KEY_ID=AKIAJTSSKJDBHFS
export AWS_SECRET_ACCESS_KEY=k+efsdkjgfbnkjbsedrfs
export AWS_SSH_KEY_NAME=secure-ssh-key
```

# How the exercises are conducted
At this point I am assuming that you already have a bucket and a SSH created and AWS credentials.

The exercises start with the *starting_skeleton* tag in this repo. Check that out as described above in a new directory on your machine.

Each step is numbered in the tags.
Each tag has 2 sets of data that will need to be replicated. The terraform files which will exist in a directory such as "scripts/aws_vpc/\*.tf" and the configuration .json file which will exist in scripts/config_files/aws_vpc.json.
You will need to create these files and fill in the content from the git pages.
Use the git page to gather this data.
```
# step 1 will yield this directory structure.
./my_git_directory
  L/scripts/
    L/config_files
      L/aws_vpc.json
    L/aws_vpc
      L/aws_vpc.tf
      L/aws_vpc_outputs.tf
```
```
# step 2 will yield this directory structure.
./my_git_directory
  L/scripts/
    L/config_files
      L/aws_vpc.json
      L/aws_bastion.json
    L/aws_vpc
      L/aws_vpc.tf
      L/aws_vpc_outputs.tf
    L/aws_bastion
      L/aws_bastion.tf
      L/aws_bastion_outputs.tf
```

Each time you copy and paste in the data for the JSON files you will need to update the bucket and location that stores the state files. This is for both the inline variables and remote state_file sections.

Below is an example. You need to change the lines that have !!CHANGE_ME!! in them.

```json
{
  "environment": "Imperial Demo",
  "tf_file_path":"scripts/aws_asg_ws",
  "variable_path":"scripts/aws_asg_ws",
  "inline_variables":{
    "vpc_region": "us-east-1",
    "aws_ssh_key_name": "${ENV['AWS_SSH_KEY_NAME']}",
    "ami_id": "ami-0b33d91d",
    "tfstate_bucket": "randy-terraform-bucket",
    "vpc_state_key": "!!CHANGE_ME!!/aws_vpc/terraform.tfstate",
    "bastion_state_key": "!!CHANGE_ME!!/aws_bastion/terraform.tfstate",
    "sqs_state_key": "!!CHANGE_ME!!/aws_sqs/terraform.tfstate",
    "rds_state_key": "!!CHANGE_ME!!/aws_rds/terraform.tfstate",
    "tag_owner": "Randy_Coburn",
    "rds_username": "whosthat",
    "rds_password": "donttellanyonethis"
  },
  "state_file":{
    "type":"s3",
    "config": {
      "region":"us-east-1",
      "bucket":"!!CHANGE_ME!!",
      "key":"!!CHANGE_ME!!/aws_asg_ws/terraform.tfstate"
    }
  },
  "custom_args":["-parallelism=10"]
}
```

# How to cheat
If you do not want to go through all the steps you can check out the completed_project tag and run the following commands.
Remember that you will still need to update your bucket and locations as mentioned above.

```shell
# Create Everything
./terraform-runner -c scripts/config_files/aws_vpc.json -a apply && \
./terraform-runner -c scripts/config_files/aws_bastion.json -a apply && \
./terraform-runner -c scripts/config_files/aws_sqs.json -a apply && \
./terraform-runner -c scripts/config_files/aws_rds.json -a apply && \
./terraform-runner -c scripts/config_files/aws_asg_ws.json -a apply

# Destory Everything
./terraform-runner -c scripts/config_files/aws_asg_ws.json -a destroy -f && \
./terraform-runner -c scripts/config_files/aws_rds.json -a destroy -f && \
./terraform-runner -c scripts/config_files/aws_sqs.json -a destroy -f && \
./terraform-runner -c scripts/config_files/aws_bastion.json -a destroy -f && \
./terraform-runner -c scripts/config_files/aws_vpc.json -a destroy -f
```

# Other material to read
Please read the Terraform Runner repo for more instruction on how to use the runner. (https://github.com/morfien101/terraform-runner)
