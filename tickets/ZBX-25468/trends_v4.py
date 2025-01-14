# https://support.zabbix.com/browse/ZBX-25468
import psycopg2
import atexit
import os
import json
import datetime

# settings

# DB
DATABASE = "trends"
USER = "zabbix"
PASSWORD="password"
HOST = "127.0.0.1"
PORT = "5432"

# files
EXPORT_DIR="/tmp/files"

########################################################################################################################

conn = psycopg2.connect(database=DATABASE, user = USER, password = PASSWORD, host = HOST, port = PORT)
cur = conn.cursor()

def close_conn():
    if conn:
        conn.close()

atexit.register(close_conn)

########################################################################################################################

def readTable(table):
    try:
        select_query = "SELECT * FROM %s order by clock ASC, itemid ASC" % table
        cur.execute(select_query)
        records  = cur.fetchall()
        # print("Data from %s table:" % records)
        # for row in records :
        #     print(type(row), row)
        return records
    except (Exception, psycopg2.Error) as error:
        print("Error while fetching data from table %s" % table, error)

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

def test_table(table_data, table_name, file_data):
    rows_not_found = 0
    rows_failed = 0
    rows_passed = 0

    print("Table: '%s'\n" % table_name)

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
    print("\nSummary for table '%s':" % table_name)
    print("Rows NOT FOUND %d" % rows_not_found)
    print("Rows FAILED    %d" % rows_failed)
    print("Rows passed    %d" % rows_passed)
    print("\n")

########################################################################################################################

db_trends = readTable("trends")
db_trends_uint = readTable("trends_uint")
file_data = readExportFiles(EXPORT_DIR)

test_table(db_trends, "trends", file_data)
test_table(db_trends_uint, "trends_uint", file_data)
