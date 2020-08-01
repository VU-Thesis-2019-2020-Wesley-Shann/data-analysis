import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back


def visit_subreddit_annoucements(device):
    # 10 steps
    print('\tVisit subReddit Announcements')

    # click in Announcements subreddit
    tap(device, 600, 1000, 5)

    # click in post 2
    tap(device, 600, 820)
    tap_phone_back(device)

    # click in post 1
    tap(device, 600, 580, 8)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)

    # click in Announcements subreddit
    tap(device, 600, 1000, 5)

    # click in post 1
    tap(device, 600, 580)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)


def visit_subreddit_ask_science(device):
    # 12 steps
    print('\tVisit subReddit Ask Science')

    # click in ask science subreddit
    tap(device, 600, 1536, 5)

    # click in post 2
    tap(device, 600, 950)
    tap_phone_back(device)

    # click in post 3
    tap(device, 600, 1200, 2)
    tap_phone_back(device)

    # click in post 1
    tap(device, 600, 700, 8)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)

    # click in ask science subreddit
    tap(device, 600, 1536, 5)

    # click in post 1
    tap(device, 600, 700)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)


def visit_subreddit_aww(device):
    # 10 steps
    print('\tVisit subReddit Aww')

    # click in aww subreddit
    tap(device, 600, 1733, 5)

    # click in post 2
    tap(device, 600, 938)
    tap_phone_back(device)

    # click in post 3 comments
    tap(device, 1340, 1100, 8)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)

    # click in aww subreddit
    tap(device, 600, 1733, 5)

    # click in post 3 comments
    tap(device, 1340, 1100)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)


def first_run(device):
    print('\tfirst action')
    # continue as anonymous
    tap(device, 720, 1440, 0)

    # click in menu
    tap(device, 1345, 165, 0)

    # click in settings
    tap(device, 940, 501, 0)

    # click in cache
    tap(device, 216, 853, 0)

    # click in checkbox to disable
    tap(device, 1318, 1194, 0)
    tap(device, 1309, 1701, 0)

    # set cache age
    tap(device, 477, 805, 0)
    tap(device, 463, 464, 0)

    # Go back to home page
    tap_phone_back(device, 0)
    tap_phone_back(device, 0)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    time.sleep(4)
    if device.current_activity().find('org.quantumbadger.redreader') != -1:
        print('\tRunning interaction for RedReader')
        first_run(device)
        visit_subreddit_ask_science(device)
        visit_subreddit_annoucements(device)
        visit_subreddit_aww(device)
    else:
        print('\tSkip file')
