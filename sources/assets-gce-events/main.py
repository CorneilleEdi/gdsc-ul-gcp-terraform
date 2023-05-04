import base64
import json
import random

import os

import functions_framework
from google.cloud import storage

FILENAME = f"pubsub_data-{random.randint(0, 9999)}.json"
PROJECT_ID = os.environ["GCP_PROJECT"]


@functions_framework.cloud_event
def handler(cloud_event):
    message = cloud_event.data['message']

    if 'data' in message:

        data = base64.b64decode(message['data']).decode('utf-8')

        filename = FILENAME
        path = "/tmp/" + filename
        with open(path, 'w') as f:
            f.write(json.dumps(json.loads(data)))

        client = storage.Client()
        bucket = client.get_bucket(f"exec-assets-bucket-{PROJECT_ID}")
        blob = bucket.blob('docs/' + filename)
        blob.upload_from_filename(path)

        return {"filename": filename}
    else:
        raise Exception("no data in the message")
