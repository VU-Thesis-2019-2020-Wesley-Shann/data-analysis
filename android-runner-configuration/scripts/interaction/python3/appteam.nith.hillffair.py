import time


def tap(device, x, y, sleep=4):
    device.shell('input tap %s %s' % (x, y))
    time.sleep(sleep)


def tap_phone_back(device, sleep=1):
    device.shell('input tap 324 2464')
    time.sleep(sleep)


def swipe(device, x1, y1, x2, y2, sleep=4, duration=1000):
    device.shell('input swipe %s %s %s %s %s' % (x1, y1, x2, y2, duration))
    time.sleep(sleep)


def visit_battle_day(device):
    print('\tvisit_battle_day')

    # battle day card
    tap(device, 337, 1104)

    # music card
    tap(device, 733, 645, 12)
    tap_phone_back(device)

    # dance card
    tap(device, 733, 1370)
    tap_phone_back(device)

    # nukkad card
    tap(device, 733, 1957, 2)
    tap_phone_back(device)

    # main menu
    tap_phone_back(device)

    # battle day card
    tap(device, 337, 1104)

    # music card
    tap(device, 733, 645)
    tap_phone_back(device)

    # main menu
    tap_phone_back(device)


def visit_quiz(device):
    print('\tvisit_quiz')

    # quiz card
    tap(device, 1053, 1173, 2)

    # instruction
    tap(device, 648, 1050)
    tap_phone_back(device)

    # leaderboard
    tap(device, 756, 1530, 8)
    tap_phone_back(device)

    # main menu
    tap_phone_back(device)

    # quiz card
    tap(device, 1053, 1173, 2)

    # leaderboard
    tap(device, 756, 1530)
    tap_phone_back(device)

    # main menu
    tap_phone_back(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('appteam.nith.hillffair') != -1:
        print('Running interaction for Hillffair')
        # visit_battle_day(device)
        visit_quiz(device)
