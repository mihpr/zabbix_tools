# https://support.zabbix.com/browse/ZBX-25468
import psycopg2
import atexit
import os
import json
import datetime

########################################################################################################################
# settings
########################################################################################################################

### DB ###
DATABASE = "trends"
USER = "zabbix"
PASSWORD="password"
HOST = "127.0.0.1"
PORT = "5432"

### exported files ###
EXPORT_DIR="/tmp/files"

### Time period to test ###

# Database records from the specified time period will be matched to records in exported files.
# It does not affect reading from JSON.
# Time is in local timezone.
# Format:
#     YYYY-MM-DD HH:MM:SS
#     TIME_FROM = "2025-03-05 13:00:00"
#     TIME_TO   = "2025-03-05 21:00:00"
# Meaning of the special value None:
#     TIME_FROM = None # removes any limit
#     TIME_TO   = None # is converted to the time when script stated execution

TIME_FROM = None
TIME_TO = None

### script performance optimizations ###

# Set to True to print only the summary and skip table output
SKIP_TABLE_OUTPUT = False
# Print progress output "<number> rows processed, working..." each REPORT_EACH_N_ROWS rows,
# if SKIP_TABLE_OUTPUT == True.
# Set to 0 to disable progress output.
REPORT_EACH_N_ROWS = 1000

# Set to True to load all exported files to memory before execution of test cases.
# If set to True, it significantly (by tens of times) improves performance,
# but requires more RAM for preloaded exported files.
# Try setting to True and then set to False if the script consumes to much RAM.
PRELOAD_ALL_EXPORTED_FILES = True

# Batch size for fetching trends from database tables with SQL queries.
FETCH_BATCH_SIZE = 1

########################################################################################################################

conn = psycopg2.connect(database=DATABASE, user = USER, password = PASSWORD, host = HOST, port = PORT)
cur = conn.cursor()

def cleanup():
    if cur:
        cur.close()
    if conn:
        conn.close()

atexit.register(cleanup)

########################################################################################################################

TIME_FORMAT = "%Y-%m-%d %H:%M:%S"

# Records buffer
row_buf = []

def openTable(table, from_ts, to_ts):
    try:
        select_query = "select * from %s where clock >= %d and clock <= %d order by clock ASC, itemid ASC" % (table, int(from_ts), int(to_ts))
        cur.execute(select_query)
    except (Exception, psycopg2.Error) as error:
        print("Error while executing select query from table %s" % table, error)

def fetchNextRow():
    global row_buf

    if FETCH_BATCH_SIZE == 1:
        return cur.fetchone()

    if not row_buf: # if empty
        row_buf = cur.fetchmany(FETCH_BATCH_SIZE)

        if not row_buf:
            return None

    return row_buf.pop(0)

def read_json_from_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    lines = [json.loads(line) for line in lines]
    return lines

def readExportFiles(exportDir):
    out = []
    for filename in os.listdir(exportDir):
        file_path = os.path.join(exportDir, filename)
        if os.path.isfile(file_path):
            # print(f'File: {filename}')
            out += read_json_from_file(file_path)

    return out

def human_to_ts(human):
    dt_object = datetime.datetime.strptime(human, TIME_FORMAT)
    return int(dt_object.timestamp())

def ts_to_human(ts):
    dt_object = datetime.datetime.fromtimestamp(ts)
    return dt_object.strftime(TIME_FORMAT)

# preloaded data is required
def match_to_json1(parsed_file_data, itemid, clock):
    for row in parsed_file_data:
        if row["itemid"] == itemid and row["clock"] == clock:
            return row
    return None

# preloaded data is not required
def match_to_json2(itemid, clock):
    for filename in os.listdir(EXPORT_DIR):
        file_path = os.path.join(EXPORT_DIR, filename)
        if os.path.isfile(file_path):
            with open(file_path, 'r') as file:
                for line in file:
                    row = json.loads(line)
                    if row["itemid"] == itemid and row["clock"] == clock:
                        return row

    return None

def now():
    dt_object = datetime.datetime.now()
    ts = int(dt_object.timestamp())
    return ts

class PrettyTable:
    def __init__(self, columns):
        self.field_names = [col[0] for col in columns]
        self.col_widths = [col[1] for col in columns]
        if not SKIP_TABLE_OUTPUT:
            self.print_header()

    def print_header(self):
        format_str = ' | '.join(f'{{:<{width}}}' for width in self.col_widths)
        print(format_str.format(*self.field_names))

    def add_row(self, row):
        format_str = ' | '.join(f'{{:<{width}}}' for width in self.col_widths)
        if not SKIP_TABLE_OUTPUT:
            print(format_str.format(*row))

def test_table(table_name, file_data):
    rows_not_found = 0
    rows_failed = 0
    rows_passed = 0
    rows_total = 0

    print("Table: '%s'\n" % table_name)

    out = PrettyTable((("clock", 11), ("clock human", 19), ("itemid", 19), ("value_min", 22), ("avg", 22), ("value_max", 22), ("num in DB", 9), ("num in files", 12)))

    while True:
        # get the next row from database and exit if done
        db_row = fetchNextRow()
        if db_row is None:
            break

        itemid = db_row[0]
        clock = db_row[1]
        clock_human = ts_to_human(clock)
        num = db_row[2]
        value_min = db_row[3]
        avg = db_row[4]
        value_max = db_row[5]


        if PRELOAD_ALL_EXPORTED_FILES:
            j = match_to_json1(file_data, itemid, clock)
        else:
            j = match_to_json2(itemid, clock)

        rows_total += 1

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

        if not SKIP_TABLE_OUTPUT:
            table_row = [clock, clock_human, itemid, value_min, avg, value_max, num, num_in_files]
            out.add_row(table_row)
        elif REPORT_EACH_N_ROWS != 0 and rows_total % REPORT_EACH_N_ROWS == 0:
                print("%d rows processed, working..." % rows_total)

    print("\nSummary for table '%s':" % table_name)
    print("Rows processed %d" % rows_total)
    print("    Rows NOT FOUND %d" % rows_not_found)
    print("    Rows FAILED    %d" % rows_failed)
    print("    Rows passed    %d" % rows_passed)

    print("\n")

def seconds_to_hms(seconds):
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    remaining_seconds = seconds % 60
    return hours, minutes, remaining_seconds

########################################################################################################################

assert isinstance(SKIP_TABLE_OUTPUT, bool), "SKIP_TABLE_OUTPUT must be a boolean"
assert isinstance(PRELOAD_ALL_EXPORTED_FILES, bool), "PRELOAD_ALL_EXPORTED_FILES must be a boolean"
assert isinstance(REPORT_EACH_N_ROWS, int), "REPORT_EACH_N_ROWS must be an integer"
assert REPORT_EACH_N_ROWS >= 0, "REPORT_EACH_N_ROWS must be greater or equal to zero"
assert os.path.isdir(EXPORT_DIR), f"ExportDir {EXPORT_DIR} does not exist"

script_stated_ts = now()
print("Script started: %s (local time zone)    timestamp: %s" % (ts_to_human(script_stated_ts), script_stated_ts))

from_ts = 0
if TIME_FROM is not None:
    from_ts = human_to_ts(TIME_FROM)

print("Matching trends from DB in range time range to exported trends")
print("From: %s (local time zone)    timestamp: %s" % (ts_to_human(from_ts), from_ts))

to_ts = script_stated_ts
if TIME_TO is not None:
    to_ts = human_to_ts(TIME_TO)
print("To:   %s (local time zone)    timestamp: %s" % (ts_to_human(to_ts), to_ts))

print("Export directory: %s" % EXPORT_DIR)

file_data = None
if PRELOAD_ALL_EXPORTED_FILES:
    file_data = readExportFiles(EXPORT_DIR)
    print("Exported files preloaded")

print("\n\n\n")

openTable("trends", from_ts, to_ts)
test_table("trends", file_data)

openTable("trends_uint", from_ts, to_ts)
test_table("trends_uint", file_data)

script_finished_ts = now()
print("Script finished: %s (local time zone)    timestamp: %s" % (ts_to_human(script_finished_ts), script_finished_ts))
script_duration = script_finished_ts - script_stated_ts
print("Script duration: %02d:%02d:%02d HH:MM:SS" % seconds_to_hms(script_duration))
