import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back
from scripts.interaction.python3.common import write_email
from scripts.interaction.python3.common import write_password


def login(device):
    print('\tlogin')

    # click on username
    tap(device, 211, 794, 1)
    write_email(device)

    # click on password
    tap(device, 261, 1013, 1)
    write_password(device)

    # click on login
    tap(device, 612, 1226, 6)

    # The actions below are required because one code was commented due to exceptions
    # click back in top menu
    tap(device, 90, 192, 1)

    # click continue
    tap(device, 904, 2208, 1)

    # click done
    tap(device, 1071, 1952, 1)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('io.github.project_travel_mate') != -1:
        print('\tRunning interaction for TravelMate')
        login(device)
    else:
        print('\tSkip file')
