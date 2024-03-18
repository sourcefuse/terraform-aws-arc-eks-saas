import os
import boto3

def handler(event, context):
    # Retrieve the crawler name from the environment variable
    crawler_name = os.environ.get('CRAWLER_NAME')
    
    if crawler_name is None:
        error_message = "Crawler name not found in environment variable 'CRAWLER_NAME'"
        print(error_message)
        return {
            'statusCode': 500,
            'body': error_message
        }

    # Create a Boto3 Glue client
    glue = boto3.client('glue')
    
    try:
        # Start the Glue crawler
        response = glue.start_crawler(Name=crawler_name)
        print("Successfully triggered crawler:", response)
        return {
            'statusCode': 200,
            'body': 'Successfully triggered crawler'
        }
    except glue.exceptions.CrawlerRunningException as e:
        # If the crawler is already running, ignore the trigger
        print('Crawler already running; ignoring trigger.')
        return {
            'statusCode': 200,
            'body': 'Crawler already running; ignoring trigger.'
        }
    except Exception as e:
        # Log any other errors
        print('Error starting crawler:', e)
        return {
            'statusCode': 500,
            'body': 'Error starting crawler'
        }
