import time


def visit_profile(device):
    print('visit profile')
    # click in side menu icon
    device.shell('input tap 80 150')
    time.sleep(1)
    # click in profile
    device.shell('input tap 300 520')
    time.sleep(4)
    # click in score tab
    device.shell('input tap 200 630')
    time.sleep(4)
    # click in info tab
    device.shell('input tap 530 630')
    time.sleep(1)
    # click in feed tab
    device.shell('input tap 900 630')
    time.sleep(4)
    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)


def visit_quiz(device):
    print('visit quiz')
    # click in quiz box
    device.shell('input tap 800 800')
    time.sleep(4)
    # click in leaderboard
    device.shell('input tap 550 1200')
    time.sleep(4)
    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)
    # click in instruction
    device.shell('input tap 550 820')
    time.sleep(4)
    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)
    # click in leaderboard
    device.shell('input tap 550 1200')
    time.sleep(8)
    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)
    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)


def visit_clubs(device):
    print('visit clubs')
    # click in clubs box
    device.shell('input tap 800 1600')
    time.sleep(8)

    # click in square in line 1 column 1
    device.shell('input tap 250 450')
    time.sleep(4)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)

    # click in square in line 2 column 2
    device.shell('input tap 800 900')
    time.sleep(4)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)

    # click in square in line 3 column 1
    device.shell('input tap 250 1350')
    time.sleep(4)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)

    # click in square in line 1 column 1
    device.shell('input tap 250 450')
    time.sleep(12)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)


def visit_battle_day(device):
    print('visit battle day')

    # click in battle day box
    device.shell('input tap 250 800')
    time.sleep(8)

    # click in music
    device.shell('input tap 500 450')
    time.sleep(12)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)

    # click in dance
    device.shell('input tap 500 1000')
    time.sleep(4)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)

    # click in nukkad
    device.shell('input tap 500 1500')
    time.sleep(4)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)

    # click in music
    device.shell('input tap 500 450')
    time.sleep(4)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)

    # click on the phone back action
    device.shell('input tap 240 1850')
    time.sleep(2)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('appteam.nith.hillffair') != -1:
        print('=INTERACTION_STAR=')
        visit_profile(device)
        visit_quiz(device)
        visit_clubs(device)
        visit_battle_day(device)
        print('=INTERACTION_END=')
