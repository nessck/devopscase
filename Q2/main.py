from google.cloud import pubsub_v1
import os 
from google.api_core.exceptions import GoogleAPICallError, RetryError

# Replace with your project ID and subscription ID
project_id = os.getenv("PROJECT_ID")
subscription_id = os.getenv("SUBSCRIPTION_NAME")

subscriber = pubsub_v1.SubscriberClient()
subscription_path = subscriber.subscription_path(project_id, subscription_id)

def callback(message):
    print('Received message: {}'.format(message))
    message.ack()


# The subscriber is non-blocking, so we must keep the main thread from
# exiting to allow it to process messages in the background.
import time
try:
    print('listening message from: {}'.format(subscription_id))
    streaming_pull_future = subscriber.subscribe(subscription_path, callback=callback)
    with subscriber:
        try:
            streaming_pull_future.result()
        except Exception as e:
            print(str(e))
    while True:
        time.sleep(60)
except GoogleAPICallError as e:
    print('A Google API call error occurred: {}'.format(e))
except RetryError as e:
    print('A Retry error occurred: {}'.format(e))
except Exception as e:
    print('An unexpected error occurred: {}'.format(e))
