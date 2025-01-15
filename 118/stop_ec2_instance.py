import boto3

region = 'ap-northeast-2'
instances = []
ec2_r = boto3.resource('ec2')
ec2 = boto3.client('ec2', region_name=region)

for instance in ec2_r.instances.all():
    for tag in instance.tags:
        if tag['Key'] == 'auto-schedule':
            if tag['Value'] == 'True':
                instances.append(instance.id)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))