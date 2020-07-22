import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back


def visit_subreddit_annoucements(device):
    # 10 steps
    print('Visit subReddit Announcements')

    # click in Announcements subreddit
    tap(device, 600, 1000)

    # click in post 1
    tap(device, 600, 580, 8)
    tap_phone_back(device)

    # click in post 2
    tap(device, 600, 820)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)

    # click in Announcements subreddit
    tap(device, 600, 1000)

    # click in post 1
    tap(device, 600, 580)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)


def visit_subreddit_ask_science(device):
    # 12 steps
    print('Visit subReddit Ask Science')

    # click in ask science subreddit
    tap(device, 600, 1536)

    # click in post 1
    tap(device, 600, 700, 8)
    tap_phone_back(device)

    # click in post 2
    tap(device, 600, 950)
    tap_phone_back(device)

    # click in post 3
    tap(device, 600, 1200, 2)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)

    # click in ask science subreddit
    tap(device, 600, 1536)

    # click in post 1
    tap(device, 600, 700)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)


def visit_subreddit_aww(device):
    # 10 steps
    print('Visit subReddit Aww')

    # click in aww subreddit
    tap(device, 600, 1733)

    # click in post 1
    tap(device, 600, 700)
    tap_phone_back(device)

    # click in post 2 comments
    tap(device, 1340, 1100, 8)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)

    # click in aww subreddit
    tap(device, 600, 1733)

    # click in post 2 comments
    tap(device, 1340, 1100)
    tap_phone_back(device)

    # Go back to home page
    tap_phone_back(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('org.quantumbadger.redreader') != -1:
        print('Running interaction for RedReader')
        visit_subreddit_ask_science(device)
        visit_subreddit_annoucements(device)
        visit_subreddit_aww(device)
    else:
        print('Skip file')
