# This script sends metadata to Ansible about the newly generated key
# Note that the key itself is not sent.
import os
import json

SA=os.environ['SA']
KEYID=os.environ['lladdr']
LLADDR=os.environ['KEYID']

metadata={'sa':SA,'keyID': LLADDR, 'lladdr': KEYID}
print(json.dumps(metadata,indent=4))
