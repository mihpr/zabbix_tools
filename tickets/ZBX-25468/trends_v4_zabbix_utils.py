# https://support.zabbix.com/browse/ZBX-25468
import zabbix_utils
import atexit
import os
import json
import datetime

# enum (no need to change)
API_AUTH_METHOD_TOKEN = 0
API_AUTH_METHOD_PASSWORD = 1

# settings (change them according to your needs)

API_URL="https://localhost/zabbix1/ui"

# You may want set this to true if zabbix_utils shows Zabbix version related errors
API_SKIP_VERSION_CHECK=True

# API
# Choose authentication method: select one API_AUTH_METHOD_TOKEN, API_AUTH_METHOD_PASSWORD
API_AUTH_MEHOD=API_AUTH_METHOD_TOKEN

# API_TOKEN is required in case API_AUTH_METHOD_TOKEN is used
# How to create a token from Zabbix frontend:
# https://www.zabbix.com/documentation/current/en/manual/web_interface/frontend_sections/users/api_tokens
API_TOKEN="e9826881e9e469e0028e0c20f8884149dbe7fefa2dfd3e625a5052726ad24c52"

# API_USER and API_PASSWORD are required in case API_AUTH_METHOD_PASSWORD is used
API_USER="Admin"
API_PASSWORD="zabbix"

# files
EXPORT_DIR="/tmp/files"

########################################################################################################################

# Connect to the Zabbix API
api = zabbix_utils.ZabbixAPI(url=API_URL, skip_version_check=API_SKIP_VERSION_CHECK)

if API_AUTH_MEHOD == API_AUTH_METHOD_TOKEN:
    api.login(token=API_TOKEN)
elif API_AUTH_MEHOD == API_AUTH_METHOD_PASSWORD:
    api.login(user=API_USER, password=API_PASSWORD)
else:
    raise Exception("Invalid value of API_SKIP_VERSION_CHECK. Check your settings.")

def close_conn():
    if api:
        api.logout()

atexit.register(close_conn)

########################################################################################################################

def readTrendsViaAPI():
    trends_data = api.trend.get({
        'output': 'extend'
    })

    records = []

    for item in trends_data:
        if "." in item['value_min']:
            value_min = float(item['value_min'])
        else:
            value_min = int(item['value_min'])

        if "." in item['value_avg']:
            value_avg = float(item['value_avg'])
        else:
            value_avg = int(item['value_avg'])

        if "." in item['value_max']:
            value_max = float(item['value_max'])
        else:
            value_max = int(item['value_max'])

        r = [
            int(item['itemid']),
            int(item['clock']),
            int(item['num']),
            value_min,
            value_avg,
            value_max,
        ]
        records.append(r)

    records.sort(key=lambda x: (x[1], x[0]))

    return records


def read_json_from_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    lines = [json.loads(line) for line in lines]
    return lines

def readExportFiles(exportDir):
    assert os.path.isdir(exportDir), f"ExportDir {EXPORT_DIR} does not exist"

    out = []
    for filename in os.listdir(exportDir):
        file_path = os.path.join(exportDir, filename)
        if os.path.isfile(file_path):
            # print(f'File: {filename}')
            out += read_json_from_file(file_path)

    return out


def ts_to_human(ts):
    return datetime.datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

def find_in_json(parsed_file_data, itemid, clock):
    for row in parsed_file_data:
        if row["itemid"] == itemid and row["clock"] == clock:
            return row
    return None

class PrettyTable:
    def __init__(self, field_names):
        self.field_names = field_names
        self.rows = []

    def add_row(self, row):
        self.rows.append(row)

    def __str__(self):
        table = [self.field_names] + self.rows
        col_widths = [max(len(str(item)) for item in col) for col in zip(*table)]
        format_str = ' | '.join(f'{{:<{width}}}' for width in col_widths)
        lines = [format_str.format(*row) for row in table]
        return '\n'.join(lines)

def test_trends(table_data, file_data):
    rows_not_found = 0
    rows_failed = 0
    rows_passed = 0

    print("All trends:\n")

    out = PrettyTable(("clock", "clock human", "itemid", "value_min", "avg", "value_max", "num", "num in files"))

    for db_row in table_data:
        itemid = db_row[0]
        clock = db_row[1]
        clock_human = ts_to_human(clock)
        num = db_row[2]
        value_min = db_row[3]
        avg = db_row[4]
        value_max = db_row[5]

        j = find_in_json(file_data, itemid, clock)
        if j is not None:
            if j["count"] == num:
                result = "passed"
                rows_passed += 1
            else:
                result = "FAILED"
                rows_failed += 1
            num_in_files = "%d %s" % (j["count"], result)
        else:
            num_in_files = "NOT FOUND"
            rows_not_found += 1

        table_row = [clock, clock_human, itemid, value_min, avg, value_max, num, num_in_files]
        out.add_row(table_row)

    print(out)
    print("\nSummary all trends")
    print("Rows NOT FOUND %d" % rows_not_found)
    print("Rows FAILED    %d" % rows_failed)
    print("Rows passed    %d" % rows_passed)
    print("\n")

########################################################################################################################

db_trends = readTrendsViaAPI()
file_data = readExportFiles(EXPORT_DIR)

test_trends(db_trends, file_data)
