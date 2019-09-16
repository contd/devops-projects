# Backup Intro
> This is take directly from the AWS documentation on AWS Backup and for local reference purposes.

AWS Backup is a fully managed backup service that makes it easy to centralize and automate the backup of data across AWS services in the cloud and on premises. Using AWS Backup, you can centrally configure backup policies and monitor backup activity for your AWS resources. AWS Backup automates and consolidates backup tasks that were previously performed service-by-service, removing the need to create custom scripts and manual processes. With just a few clicks on the AWS Backup console, you can create backup policies that automate backup schedules and retention management.

AWS Backup provides a fully managed, policy-based backup solution, simplifying your backup management, and enabling you to meet your business and regulatory backup compliance requirements.

## Supported

| **Supported Service**  |  **Supported Resource** |
| --- | --- |
| Amazon Elastic File System (Amazon EFS)   |  Amazon EFS file systems |
| Amazon DynamoDB (DynamoDB)  |  DynamoDB tables |
| Amazon Elastic Block Store (Amazon EBS)  |  Amazon EBS volumes |
| Amazon Relational Database Service (Amazon RDS)  |  Amazon RDS databases* |
| AWS Storage Gateway (Volume Gateway)  |  AWS Storage Gateway volumes |

## Provides
**Centralized Backup Management**
AWS Backup provides a centralized backup console, a set of backup APIs, and the AWS Command Line Interface (AWS CLI) to manage backups across the AWS services that your applications use. With AWS Backup, you can centrally manage backup policies that meet your backup requirements. You can then apply them to your AWS resources across AWS services, enabling you to back up your application data in a consistent and compliant manner. The AWS Backup centralized backup console offers a consolidated view of your backups and backup activity logs, making it easier to audit your backups and ensure compliance.

**Policy-Based Backup Solutions**
With AWS Backup, you can create backup policies known as backup plans. Use these backup plans to define your backup requirements and then apply them to the AWS resources that you want to protect across the AWS services that you use. You can create separate backup plans that each meet specific business and regulatory compliance requirements. This helps ensure that each AWS resource is backed up according to your requirements. Backup plans make it easy to enforce your backup strategy across your organization and across your applications in a scalable manner.

**Tag-Based Backup Policies**
You can use AWS Backup to apply backup plans to your AWS resources by tagging them. Tagging makes it easier to implement your backup strategy across all your applications and to ensure that all your AWS resources are backed up and protected. AWS tags are a great way to organize and classify your AWS resources. Integration with AWS tags enables you to quickly apply a backup plan to a group of AWS resources, so that they are backed up in a consistent and compliant manner.

**Backup Activity Monitoring**
AWS Backup provides a dashboard that makes it simple to audit backup and restore activity across AWS services. With just a few clicks on the AWS Backup console, you can view the status of recent backup jobs. You can also restore jobs across AWS services to ensure that your AWS resources are properly protected.
AWS Backup integrates with AWS CloudTrail. CloudTrail gives you a consolidated view of backup activity logs that make it quick and easy to audit how your resources are backed up. AWS Backup also integrates with Amazon Simple Notification Service (Amazon SNS), providing you with backup activity notifications, such as when a backup succeeds or a restore has been initiated.

**Lifecycle Management Policies**
AWS Backup enables you to meet compliance requirements while minimizing backup storage costs by storing backups in a low-cost cold storage tier. You can configure lifecycle policies that automatically transition backups from warm storage to cold storage according to a schedule that you define.

**Backup Access Policies**
AWS Backup offers resource-based access policies for your backup vaults to define who has access to your backups. You can define access policies for a backup vault that define who has access to the backups within that vault and what actions they can take. This provides a simple and secure way to control access to your backups across AWS services, helping you meet your compliance requirements.

### More Info
- [Using AWS Backup with Amazon EFS](https://docs.aws.amazon.com/efs/latest/ug/awsbackup.html)
- [Amazon EBS Snapshots](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html)