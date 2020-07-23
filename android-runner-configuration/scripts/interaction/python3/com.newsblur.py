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
    tap(device, 1210, 1056, 6)


def visit_global_stories(device):
    print('\tvisit_global_stories')

    # click on global stories
    tap(device, 594, 330)

    # click on card 1
    tap(device, 436, 453, 8)
    tap_phone_back(device)

    # click on card 2
    tap(device, 435, 858)
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)

    # click on global stories
    tap(device, 594, 330)

    # click on card 1
    tap(device, 436, 453)
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)


def visit_all_shared_stories(device):
    print('\tvisit_all_shared_stories')

    # click on all shared stories
    tap(device, 553, 442)

    # click on card 1
    tap(device, 436, 453, 8)
    tap_phone_back(device)

    # click on card 2
    tap(device, 435, 858)
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)

    # click on all shared stories
    tap(device, 553, 442)

    # click on card 1
    tap(device, 436, 453)
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('com.newsblur') != -1:
        print('\tRunning interaction for NewsBlur')
        login(device)
        visit_global_stories(device)
        visit_all_shared_stories(device)
    else:
        print('\tSkip file')
