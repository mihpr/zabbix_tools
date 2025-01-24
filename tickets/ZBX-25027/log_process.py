import os
import json

# Define the file paths
src = os.path.abspath("/tmp/zabbix_server.log")
dst = os.path.abspath("/tmp/zabbix_server_out.log")

token = "[ZBX-25468] "
# key_order = ['now', 'nextcheck', 'delayed', 'key', 'type', 'value_type', 'state', 'status', 'location', 'poller_type', 'error', 'host', 'proxyid']
# key_order = ['now', 'nextcheck']
# key_order = ['now', 'port']
key_order = None

# Open the source file in read mode and the destination file in write mode
with open(src, 'r') as src_file, open(dst, 'w') as dst_file:

    # Read each line from the source file
    for line in src_file:
        if key_order is None:
            dst_file.write(line)
            continue

        # Check if the line contains "[ZBX-25468]"
        if token in line:
            # Extract everything after "[ZBX-25468]"
            prefix  = line.split(token)[0]
            json_string = line.split(token)[1]
            # Parse the JSON string into a dictionary
            data = json.loads(json_string)

            # Create a new dictionary with the keys in the desired order

            ordered_data = {key: data[key] for key in key_order}

            # Convert the ordered dictionary back to a JSON string
            # ordered_json_string = json.dumps(ordered_data, indent=4)
            ordered_json_string = json.dumps(ordered_data)

            dst_file.write(prefix + token + ordered_json_string + "\n")
        else:
            dst_file.write(line)
