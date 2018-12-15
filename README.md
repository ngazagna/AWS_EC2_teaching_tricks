# AWS_EC2_teaching_tricks
This repository lists useful tricks when one uses AWS EC2 as a teaching tools.

## Sharing an AMI image with a list of accounts

Let say that you have asked your students to create there own AWS accounts, and you now want to share with them the private AMI of the machine you want them to work on. Let `aws_ids.txt` a file containing the AWS account number (one by line) with whom you want to share your AMI.

The goal of this short tutorial is to help your configuring your AWS account and give you a small bash script looping over the lines of `aws_ids.txt` and adding each AWS account to the list of permissions.

### 1) Setting up your IAM (Identify and Access Management)

1. Go on your [IAM console](https://console.aws.amazon.com/iam/home?#/home).
2. Click on **Users**.
3. Create a user if you don't have one already. Click on your user name (not on the tick box).
4. Click on the **Security credentials** tab.
5. Click on **Create access key**.
6. Click on **Show** to see your access key. Identification information will be displayed that way:
   - Access key ID: AKIAIOSFODNN7EXAMPLE
   - Secret access key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

7. You can also download the the key pair into a *.csv* file.

For more detailed instructions, have a look at the [AWS doc](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration).

### 2) Managing your policies

Once that you have an IAM user and a corresponding access key pair, you need to ensure that it has the right to share your private AMIs with other accounts. The easiest way to do so is the following:

1. Once again, go on [IAM console](https://console.aws.amazon.com/iam/home?#/home).
2. Click on **Policies** in the left-hand menu.
3. Copy the following Administrator permissions code:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
```
4. Click on **Create policy**, then on the **JSON** tab and paste the previous piece of code.
5. Click on **Review policy** and give it a name.
6. In the **Policies** section, select the created policy, click on **Policy actions > Attach** and select the user name your create in the previous paragraph. 

If you don't follow this step, you will end up with this [Stack Overflow error](https://stackoverflow.com/questions/28222445/aws-cli-client-unauthorizedoperation-even-when-keys-are-set).


### 3) Installing and use AWS-CLI to add an image

1. Open a terminal and run the following code to install AWS-CLI:
```
pip install awscli --upgrade --user
```
The corresponding documentation is available [here](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/installing.html).

Now you need to configure *awscli* in a terminal. It doesn't who your are yet!

1. In your terminal, run
```
aws configure
```
and fill incrementally the IAM key pair you obtained in **Section 1)** and other inputs, e.g.
```
AWS Access Key ID [None]: AKIAI44QH8DHBEXAMPLE
AWS Secret Access Key [None]: je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
Default region name [None]: eu-west-1
Default output format [None]: text
```
Note that in our example, we selected the EU (Ireland) region by setting the third parameter to *eu-west-1*. The list of the region names is available [here](https://docs.aws.amazon.com/general/latest/gr/rande.html).


3. A good way to check if your configuration is correct is to try to share your AMI with a single AWS account using AWS CLI. In your terminal, try to run a code like:
```
aws ec2 modify-image-attribute --image-id ami-12345678 --launch-permission "Add=[{UserId=123456789012}]"
```
where *ami-12345678* stands for the AMI ID you want to share and *123456789012* stands for the ID of the account you want to share your AMI with.

Help [here](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/sharingamis-explicit.html).


### 4) Sharing a private AMI with a list of AWS accounts

Now that you can share your AMI with one account using AWS CLI, you can easily share it with a plenty of them by just stacking all the AWS accounts in a `aws_ids.txt` file (one ID per line) and running the bash code provided in this repository: `share_ami_with_aws_ids.sh`.

1. First, put both files `share_ami_with_aws_ids.sh` and `aws_ids.txt` in the same folder.

2. Then, you need to modify `share_ami_with_aws_ids.sh` to fit your settings. Open it in any text editor and
   - Enter the AMI ID in place of *your-ami-id*.
   - Enter your region in place of *your-region*.

2. Finally, to share your ami with all the AWS accounts just launch:
```
./share_ami_with_aws_ids.sh aws_ids.txt
```

**Remark:** when dealing with bash files in linux, do not forget to allow the execution of the file. In order to do so, run
```
chmod +x share_ami_with_aws_ids.sh
```