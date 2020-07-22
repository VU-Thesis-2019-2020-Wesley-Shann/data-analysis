import time


#######################
# COMMON INTERACTION #
#######################
def tap(device, x, y, sleep=4):
    device.shell('input tap %s %s' % (x, y))
    time.sleep(sleep)


def tap_phone_back(device, sleep=1):
    device.shell('input tap 324 2464')
    time.sleep(sleep)


def tap_close_keyboard(device, sleep=1):
    device.shell('input tap 324 2464')
    time.sleep(sleep)


def write_text(device, text, sleep=1):
    device.shell('input text \'%s\'' % text)
    time.sleep(sleep)


def write_email(device):
    write_text(device, 'nappatest@outlook.com', 0)


def write_password(device):
    write_text(device, 'NappaTest1!', 0)


def swipe(device, x1, y1, x2, y2, sleep=4, duration=1000):
    device.shell('input swipe %s %s %s %s %s' % (x1, y1, x2, y2, duration))
    time.sleep(sleep)


########################
# THIS APP INTERACTION #
########################
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


def visit_clubs(device):
    print('\tvisit_clubs')

    # club card
    tap(device, 1084, 2213)

    # PR club card
    tap(device, 369, 554)
    tap_phone_back(device)

    # Design and decoration card
    tap(device, 1012, 1152, 12)
    tap_phone_back(device)

    # Technical comite card
    tap(device, 255, 1845)
    tap_phone_back(device)

    # main menu
    tap_phone_back(device)

    # club card
    tap(device, 1084, 2213)

    # Design and decoration card
    tap(device, 1012, 1152)
    tap_phone_back(device)

    # main menu
    tap_phone_back(device)


def accept_and_login(device):
    print('\taccept_and_login')

    # skip
    tap(device, 1291, 2314, 2)

    # select theme
    tap(device, 355, 752, 2)

    # Write email
    tap(device, 193, 928, 1)
    write_email(device)

    # Write password
    tap(device, 247, 1162, 1)
    write_password(device)

    # close keyboard
    tap_close_keyboard(device)

    # login
    tap(device, 373, 1498)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('appteam.nith.hillffair') != -1:
        print('Running interaction for Hillffair')
        accept_and_login(device)
        visit_battle_day(device)
        visit_quiz(device)
        visit_clubs(device)
    else:
        print('Skip file')
