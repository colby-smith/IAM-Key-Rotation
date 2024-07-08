import boto3
import os

iam_client = boto3.client('iam')
ssm_client = boto3.client('ssm')

user_name = os.environ['USER_NAME']
new_key_description = os.environ.get('NEW_KEY_DESCRIPTION', 'New access key')
parameter_prefix = os.environ.get('PARAMETER_PREFIX', '/myapp/access-keys/')

def lambda_handler(event, context):
    try:
        response = iam_client.list_access_keys(UserName=user_name)
        access_keys = response['AccessKeyMetadata']
        
        if len(access_keys) == 0:
            raise Exception(f"No access keys found for user {user_name}.")

        old_access_key_id = access_keys[0]['AccessKeyId']
        
        old_access_key_id_param = f'{parameter_prefix}{user_name}_access_key_id'
        old_access_key_secret_param = f'{parameter_prefix}{user_name}_access_key_secret'
        
        try:
            ssm_client.delete_parameter(Name=old_access_key_id_param)
            print(f"Deleted parameter: {old_access_key_id_param}")
        except ssm_client.exceptions.ParameterNotFound:
            print(f"No previous parameter found for: {old_access_key_id_param}")
        
        try:
            ssm_client.delete_parameter(Name=old_access_key_secret_param)
            print(f"Deleted parameter: {old_access_key_secret_param}")
        except ssm_client.exceptions.ParameterNotFound:
            print(f"No previous parameter found for: {old_access_key_secret_param}")

        response = iam_client.create_access_key(
            UserName=user_name
        )
        new_access_key_id = response['AccessKey']['AccessKeyId']
        new_secret_access_key = response['AccessKey']['SecretAccessKey']

        ssm_client.put_parameter(
            Name=f'{parameter_prefix}{user_name}_access_key_id',
            Value=new_access_key_id,
            Type='SecureString',
            Overwrite=True
        )
        ssm_client.put_parameter(
            Name=f'{parameter_prefix}{user_name}_access_key_secret',
            Value=new_secret_access_key,
            Type='SecureString',
            Overwrite=True
        )

        iam_client.delete_access_key(
            UserName=user_name,
            AccessKeyId=old_access_key_id
        )

        return {
            'statusCode': 200,
            'body': f'Successfully rotated access keys for user {user_name}.'
        }

    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': str(e)
        }
