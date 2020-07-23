import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back
from scripts.interaction.python3.common import write_username
from scripts.interaction.python3.common import write_password


def login(device):
    print('\tlogin')

    # click on username
    tap(device, 310, 602, 1)
    write_username(device)

    # click on password
    tap(device, 297, 858, 1)
    write_password(device)

    # click on login
    tap(device, 1210, 1056)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('com.newsblur') != -1:
        print('\tRunning interaction for NewsBlur')
        login(device)
    else:
        print('\tSkip file')
