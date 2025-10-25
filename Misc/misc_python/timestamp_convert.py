import argparse
from math import floor
import re
from datetime import datetime
from datetime import timezone

epoch_pattern = r"^\d*$"
iso_pattern = r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}.*$"

def main():
    parser = argparse.ArgumentParser(
        description='Convert timestamps between ISO and Epoch. Always assumes and uses milliseconds granularity'
    )
    parser.add_argument(
        'timestamp',
        help='The provided timestamp that needs converting. If epoch is provided, will convert to ISO, and vice-versa.'
    )
    parser.add_argument(
        '--local',
        '-l',
        action='store_true',
        help='If flag is provided, use the local timezone. If not, defaults to GMT/UTC timezone. ' +
            'Has no affect unless converting epoch to ISO. ' +
            'If converting ISO to epoch, the ISO suffix indicates how to interpret the timezone. ' +
            'If ISO ends with Z, it is GMT/UTC. If it ends with nothing, it is local.'
    )
    args = parser.parse_args()
    if re.search(epoch_pattern, args.timestamp):
        print(convert_from_epoch(args.timestamp, args.local))
    elif re.search(iso_pattern, args.timestamp):
        print(convert_from_iso(args.timestamp))
    else:
        print("Did not match either epoch or iso regex patterns")

def convert_from_epoch(epoch_timestamp_milliseconds, use_local):
    timezone_object = get_local_timezone_object() if use_local else timezone.utc

    epoch_timestamp_seconds = int(epoch_timestamp_milliseconds) / 1000
    parsed_time = datetime.fromtimestamp(epoch_timestamp_seconds, timezone_object)

    iso_string = parsed_time.isoformat(timespec='milliseconds')

    # Prefer the letter Z to reflect the GMT/UTC timezone.
    return iso_string.replace('+00:00', 'Z')

# Hack from https://stackoverflow.com/a/39079819
def get_local_timezone_object():
    return datetime.now().astimezone().tzinfo

def convert_from_iso(iso_timestamp):
    parsed_time = datetime.fromisoformat(iso_timestamp)

    # Manually convert from seconds granularity to milliseconds granularity
    return floor(parsed_time.timestamp() * 1000)

if __name__ == "__main__":
    main()
