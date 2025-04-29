import os
import json
from deserialize import deserialize

# Define the file paths
src = os.path.abspath("/tmp/ZBX-25468.log")
dst = os.path.abspath("/tmp/ZBX-25468_out.log")

token = "[ZBX-25468] "

# key_order = None # all keys
key_order = ['i_itemid', 'now', 'delayed', 'i_hostid', 'i_nextcheck', 'i_item_data_expected_from', 'h_data_expected_from', 'i_value_type', 'i_flags', 'key', 'delay']
# key_order = ['i_itemid', 'now', 'delayed']

# Open the source file in read mode and the destination file in write mode
with open(src, 'r') as src_file, open(dst, 'w') as dst_file:
    # Read each line from the source file
    for line in src_file:
        # Check if the line contains "[ZBX-25468]"
        if token in line:
            # Extract everything after "[ZBX-25468]"
            prefix  = line.split(token)[0]
            json_string = line.split(token)[1]
            # Parse the JSON string into a dictionary
            # This does not work with data like 'net.if.in["eth0"]': data = json.loads(json_string)
            json_string = json_string[2:-2]
            data = json_string.split('","')

            d = dict()

            buf_base64 = deserialize(data[0])
            d |= buf_base64
            d['key'] = data[1]
            d['port'] = data[2]
            d['error'] = data[3]
            d['delay'] = data[4]
            d['delay_ex'] = data[5]
            d['history_period'] = data[6]
            d['timeout'] = data[7]

            if key_order is None:
                key_order = d.keys()

            ordered_dict = {}
            for key in key_order:
                if key in d:
                    ordered_dict[key] = d[key]
                else:
                    print(f"Error: '{key}' is missing in data")

            dst_file.write(prefix + token + str(ordered_dict) + "\n")
        else:
            dst_file.write(line)
