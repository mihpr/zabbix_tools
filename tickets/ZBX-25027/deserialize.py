import base64
import struct

def type_to_str(item_type):
    ITEM_TYPE_ZABBIX = 0
    ITEM_TYPE_TRAPPER = 2
    ITEM_TYPE_SIMPLE = 3
    ITEM_TYPE_INTERNAL = 5
    ITEM_TYPE_ZABBIX_ACTIVE = 7
    ITEM_TYPE_HTTPTEST = 9
    ITEM_TYPE_EXTERNAL = 10
    ITEM_TYPE_DB_MONITOR = 11
    ITEM_TYPE_IPMI = 12
    ITEM_TYPE_SSH = 13
    ITEM_TYPE_TELNET = 14
    ITEM_TYPE_CALCULATED = 15
    ITEM_TYPE_JMX = 16
    ITEM_TYPE_SNMPTRAP = 17
    ITEM_TYPE_DEPENDENT = 18
    ITEM_TYPE_HTTPAGENT = 19
    ITEM_TYPE_SNMP = 20
    ITEM_TYPE_SCRIPT = 21
    ITEM_TYPE_BROWSER = 22

    return {
        ITEM_TYPE_ZABBIX: "ZABBIX",
        ITEM_TYPE_TRAPPER: "TRAPPER",
        ITEM_TYPE_SIMPLE: "SIMPLE",
        ITEM_TYPE_INTERNAL: "INTERNAL",
        ITEM_TYPE_ZABBIX_ACTIVE: "ZABBIX_ACTIVE",
        ITEM_TYPE_HTTPTEST: "HTTPTEST",
        ITEM_TYPE_EXTERNAL: "EXTERNAL",
        ITEM_TYPE_DB_MONITOR: "DB_MONITOR",
        ITEM_TYPE_IPMI: "IPMI",
        ITEM_TYPE_SSH: "SSH",
        ITEM_TYPE_TELNET: "TELNET",
        ITEM_TYPE_CALCULATED: "CALCULATED",
        ITEM_TYPE_JMX: "JMX",
        ITEM_TYPE_SNMPTRAP: "SNMPTRAP",
        ITEM_TYPE_DEPENDENT: "DEPENDENT",
        ITEM_TYPE_HTTPAGENT: "HTTPAGENT",
        ITEM_TYPE_SNMP: "SNMP",
        ITEM_TYPE_SCRIPT: "SCRIPT",
        ITEM_TYPE_BROWSER: "BROWSER"
    }.get(item_type, "ITEM_TYPE ???")


def value_type_to_str(item_value_type):
    ITEM_VALUE_TYPE_FLOAT = 0
    ITEM_VALUE_TYPE_STR = 1
    ITEM_VALUE_TYPE_LOG = 2
    ITEM_VALUE_TYPE_UINT64 = 3
    ITEM_VALUE_TYPE_TEXT = 4
    ITEM_VALUE_TYPE_BIN = 5  # Last real value
    ITEM_VALUE_TYPE_NONE = 6  # Artificial value, not written into DB, used internally in server

    return {
        ITEM_VALUE_TYPE_FLOAT: "FLOAT",
        ITEM_VALUE_TYPE_STR: "STR",
        ITEM_VALUE_TYPE_LOG: "LOG",
        ITEM_VALUE_TYPE_UINT64: "UINT64",
        ITEM_VALUE_TYPE_TEXT: "TEXT",
        ITEM_VALUE_TYPE_BIN: "BIN",
        ITEM_VALUE_TYPE_NONE: "NONE"
    }.get(item_value_type, "ITEM_VALUE_TYPE ???")


def poller_type_to_str(poller_type):
    ZBX_NO_POLLER = 255
    ZBX_POLLER_TYPE_NORMAL = 0
    ZBX_POLLER_TYPE_UNREACHABLE = 1
    ZBX_POLLER_TYPE_IPMI = 2
    ZBX_POLLER_TYPE_PINGER = 3
    ZBX_POLLER_TYPE_JAVA = 4
    ZBX_POLLER_TYPE_HISTORY = 5
    ZBX_POLLER_TYPE_ODBC = 6
    ZBX_POLLER_TYPE_HTTPAGENT = 7
    ZBX_POLLER_TYPE_AGENT = 8
    ZBX_POLLER_TYPE_SNMP = 9
    ZBX_POLLER_TYPE_INTERNAL = 10
    ZBX_POLLER_TYPE_BROWSER = 11
    # ZBX_POLLER_TYPE_COUNT = 12  # number of poller types

    return {
        ZBX_NO_POLLER: "NO_POLLER",
        ZBX_POLLER_TYPE_NORMAL: "NORMAL",
        ZBX_POLLER_TYPE_UNREACHABLE: "UNREACHABLE",
        ZBX_POLLER_TYPE_IPMI: "IPMI",
        ZBX_POLLER_TYPE_PINGER: "PINGER",
        ZBX_POLLER_TYPE_JAVA: "JAVA",
        ZBX_POLLER_TYPE_HISTORY: "HISTORY",
        ZBX_POLLER_TYPE_ODBC: "ODBC",
        ZBX_POLLER_TYPE_HTTPAGENT: "HTTPAGENT",
        ZBX_POLLER_TYPE_AGENT: "AGENT",
        ZBX_POLLER_TYPE_SNMP: "SNMP",
        ZBX_POLLER_TYPE_INTERNAL: "INTERNAL",
        ZBX_POLLER_TYPE_BROWSER: "BROWSER"
    }.get(poller_type, "POLLER_TYPE ???")


def state_to_str(state):
    ITEM_STATE_NORMAL = 0
    ITEM_STATE_NOTSUPPORTED = 1

    return {
        ITEM_STATE_NORMAL: "NORMAL",
        ITEM_STATE_NOTSUPPORTED: "NOTSUPPORTED"
    }.get(state, "ITEM_STATE ???")

def host_maintenance_status_to_str(status):
    HOST_MAINTENANCE_STATUS_OFF = 0
    HOST_MAINTENANCE_STATUS_ON = 1

    return {
        HOST_MAINTENANCE_STATUS_OFF: "OFF",
        HOST_MAINTENANCE_STATUS_ON: "ON"
    }.get(status, "HOST_MAINTENANCE_STATUS ???")


def location_to_str(location):
    ZBX_LOC_NOWHERE = 0
    ZBX_LOC_QUEUE = 1
    ZBX_LOC_POLLER = 2

    return {
        ZBX_LOC_NOWHERE: "NOWHERE",
        ZBX_LOC_QUEUE: "QUEUE",
        ZBX_LOC_POLLER: "POLLER"
    }.get(location, "LOCATION ???")


def item_status_to_str(status):
    ITEM_STATUS_ACTIVE = 0
    ITEM_STATUS_DISABLED = 1

    return {
        ITEM_STATUS_ACTIVE: "ACTIVE",
        ITEM_STATUS_DISABLED: "DISABLED"
    }.get(status, "ITEM_STATUS ???")


def queue_priority_to_str(priority):
    ZBX_QUEUE_PRIORITY_HIGH = 0
    ZBX_QUEUE_PRIORITY_NORMAL = 1
    ZBX_QUEUE_PRIORITY_LOW = 2

    return {
        ZBX_QUEUE_PRIORITY_HIGH: "HIGH",
        ZBX_QUEUE_PRIORITY_NORMAL: "NORMAL",
        ZBX_QUEUE_PRIORITY_LOW: "LOW"
    }.get(priority, "PRIORITY ???")

def host_maintenance_type_to_str(maintenance_type):
    MAINTENANCE_TYPE_NORMAL = 0
    MAINTENANCE_TYPE_NODATA = 1

    return {
        MAINTENANCE_TYPE_NORMAL: "NORMAL",
        MAINTENANCE_TYPE_NODATA: "NODATA"
    }.get(maintenance_type, "MAINTENANCE_TYPE ???")

def host_status_to_str(status):
    HOST_STATUS_MONITORED = 0
    HOST_STATUS_NOT_MONITORED = 1
    HOST_STATUS_TEMPLATE = 3

    return {
        HOST_STATUS_MONITORED: "MONITORED",
        HOST_STATUS_NOT_MONITORED: "NOT_MONITORED",
        HOST_STATUS_TEMPLATE: "TEMPLATE"
    }.get(status, "HOST_STATUS ???")

def host_monitored_by_to_str(monitored_by):
    HOST_MONITORED_BY_SERVER = 0
    HOST_MONITORED_BY_PROXY = 1
    HOST_MONITORED_BY_PROXY_GROUP = 2

    return {
        HOST_MONITORED_BY_SERVER: "SERVER",
        HOST_MONITORED_BY_PROXY: "PROXY",
        HOST_MONITORED_BY_PROXY_GROUP: "PROXY_GROUP"
    }.get(monitored_by, "HOST_MONITORED_BY ???")

def deserialize_base64(encoded_str):
    # Decode the base64 string
    decoded_bytes = base64.b64decode(encoded_str)

#     # Ensure the decoded bytes length is correct
#     if len(decoded_bytes) != 91:
#         raise ValueError("Decoded bytes length is not 91 bytes")

    # Unpack the decoded bytes according to the structure
    # Q: Unsigned long long (8 bytes) - This appears six times, so it will unpack six 8-byte values.
    # q: Signed long long (8 bytes) - This appears four times, so it will unpack four 8-byte values.
    # B: Unsigned char (1 byte) - This appears seventeen times, so it will unpack seventeen 1-byte values.
    unpacked_data = struct.unpack('QQQQQQqqqqqqBBBBBBBBBBBBBBB', decoded_bytes)

    # Create a dictionary to hold the deserialized data
    deserialized_data = {
        'i_itemid': unpacked_data[0],
        'i_hostid': unpacked_data[1],
        'i_interfaceid': unpacked_data[2],
        'i_lastlogsize': unpacked_data[3],
        'i_revision': unpacked_data[4],
        'i_templateid': unpacked_data[5],
        'now': unpacked_data[6],
        'i_nextcheck': unpacked_data[7],
        'i_mtime': unpacked_data[8],
        'i_item_data_expected_from': unpacked_data[9],
        'h_data_expected_from': unpacked_data[10],
        'h_maintenance_from': unpacked_data[11],
        'i_type': unpacked_data[12],
        'i_value_type': unpacked_data[13],
        'i_poller_type': unpacked_data[14],
        'i_state': unpacked_data[15],
        'i_db_state': unpacked_data[16],
        'i_inventory_link': unpacked_data[17],
        'i_location': unpacked_data[18],
        'i_flags': unpacked_data[19],
        'i_status': unpacked_data[20],
        'i_queue_priority': unpacked_data[21],
        'i_update_triggers': unpacked_data[22],
        'h_maintenance_status': unpacked_data[23],
        'h_maintenance_type': unpacked_data[24],
        'h_host_status': unpacked_data[25],
        'h_monitored_by': unpacked_data[26],
    }

    return deserialized_data

# Example usage
def deserialize(encoded_str):
    try:
        deserialized_data = deserialize_base64(encoded_str)

        deserialized_data['i_type'] = type_to_str(deserialized_data['i_type'])
        deserialized_data['i_value_type'] = value_type_to_str(deserialized_data['i_value_type'])
        deserialized_data['i_poller_type'] = poller_type_to_str(deserialized_data['i_poller_type'])
        deserialized_data['i_state'] = state_to_str(deserialized_data['i_state'])
        deserialized_data['i_location'] = location_to_str(deserialized_data['i_location'])
        deserialized_data['i_status'] = item_status_to_str(deserialized_data['i_status'])
        deserialized_data['i_queue_priority'] = queue_priority_to_str(deserialized_data['i_queue_priority'])

        deserialized_data['h_maintenance_status'] = host_maintenance_status_to_str(deserialized_data['h_maintenance_status'])
        deserialized_data['h_maintenance_type'] = host_maintenance_type_to_str(deserialized_data['h_maintenance_type'])
        deserialized_data['h_host_status'] = host_status_to_str(deserialized_data['h_host_status'])
        deserialized_data['h_monitored_by'] = host_monitored_by_to_str(deserialized_data['h_monitored_by'])
        deserialized_data['delayed'] = int(deserialized_data['now']) - int(deserialized_data['i_nextcheck'])

        # print(deserialized_data)
        return deserialized_data
    except ValueError as e:
        print(e)
        return None

if __name__ == "__main__":
    encoded_str = "kL0AAAAAAACdKQAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAsaqXZwAAAACGqpdnAAAAAAAAAAAAAAAAkqqXZwAAAACSqpdnAAAAAAAAAAAAAAAABQP/AAAAAAAAAQAAAAAB"
    data = deserialize(encoded_str)
    print(data)