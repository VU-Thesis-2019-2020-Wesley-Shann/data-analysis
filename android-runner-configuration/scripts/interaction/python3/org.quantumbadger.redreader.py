import time


def tap(device, x, y, sleep=4):
    device.shell('input tap %s %s' % (x, y))
    time.sleep(sleep)


def tap_phone_back(device, sleep=1):
    device.shell('input tap 324 2464')
    time.sleep(sleep)


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


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('org.quantumbadger.redreader') != -1:
        print('Running interaction for RedReader')
        visit_subreddit_ask_science(device)
        visit_subreddit_annoucements(device)
