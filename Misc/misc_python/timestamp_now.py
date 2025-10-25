import argparse
from datetime import datetime
from datetime import timezone
from math import floor

def main():
    parser = argparse.ArgumentParser(description='Prints the current timestamp in either ISO or Epoch. Always uses milliseconds.')
    parser.add_argument(
        '--iso',
        '-i',
        action='store_true',
        help='If flag is provided, use ISO format. If not, defaults to epoch timestamp.'
    )
    parser.add_argument(
        '--local',
        '-l',
        action='store_true',
        help='If flag is provided, use the local timezone. If not, defaults to GMT/UTC timezone. ' +
            'Has no affect unless combined with --iso flag.'
    )
    args = parser.parse_args()

    timezone_object = get_local_timezone_object() if args.local else timezone.utc
    now = datetime.now(timezone_object)

    if args.iso:
        iso_string = now.isoformat(timespec='milliseconds')

        # Prefer the letter Z to reflect the GMT/UTC timezone.
        print(iso_string.replace('+00:00', 'Z'))
    else:
        # Manually convert from seconds granularity to milliseconds granularity
        print(floor(now.timestamp() * 1000))

# Hack from https://stackoverflow.com/a/39079819
def get_local_timezone_object():
    return datetime.now().astimezone().tzinfo


if __name__ == "__main__":
    main()
