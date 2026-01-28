import boto3 
import os 
import logging 
# Initialize AWS SDK 
ec2 = boto3.client('ec2') 
sns = boto3.client('sns') 
logger = logging.getLogger() 
logger.setLevel(logging.INFO) 
 
def lambda_handler(event, context): 
    # Variables passed from Terraform environment 
    INSTANCE_ID = os.environ['INSTANCE_ID'] 
    SNS_TOPIC = os.environ['SNS_TOPIC_ARN'] 
     
    try: 
        logger.info(f"High latency alert received. Rebooting instance: {INSTANCE_ID}") 
         
        # Reboot the EC2 instance 
        ec2.reboot_instances(InstanceIds=[INSTANCE_ID]) 
         
        # Send SNS Notification 
        sns.publish( 
            TopicArn=SNS_TOPIC, 
            Subject="REMEDIATION: EC2 Reboot Triggered", 
            Message=f"Latency on /api/data exceeded 3s. Instance {INSTANCE_ID} has been rebooted." 
        ) 
         
        return {"status": "success", "action": "reboot"} 
         
    except Exception as e: 
        logger.error(f"Error executing remediation: {str(e)}") 
        return {"status": "error", "message": str(e)}