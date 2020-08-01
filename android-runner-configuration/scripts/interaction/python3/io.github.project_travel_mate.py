import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back
from scripts.interaction.python3.common import write_email
from scripts.interaction.python3.common import write_password
from scripts.interaction.python3.common import swipe


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


def visit_delhi(device):
    print('\tvisit_delhi')

    # This closes the stoplight, removed direct from the app
    # time.sleep(2)
    # # click done
    # tap(device, 1066, 1962, 2)
    time.sleep(2)
    # click delhi
    tap(device, 346, 709)

    # click in fun facts
    tap(device, 504, 1706)
    tap_phone_back(device)

    # click in know more
    tap(device, 693, 1450, 8)
    tap_phone_back(device)

    # return to main page
    tap_phone_back(device)

    # click delhi
    tap(device, 346, 709)

    # click in know more
    tap(device, 693, 1450)
    tap_phone_back(device)

    # return to main page
    tap_phone_back(device)


def visit_mumbai_weather_via_utility(device):
    print('\tvisit_mumbai_weather_via_utility')

    # click side menu
    tap(device, 117, 170, 0)

    # click util
    tap(device, 355, 1674, 2)

    # click weather
    tap(device, 733, 1354, 2)

    # click select city
    tap(device, 724, 421, 1)

    # click city 2 - mumbai
    tap(device, 634, 1024)
    tap_phone_back(device)

    # back to util
    tap_phone_back(device)

    # click weather
    tap(device, 733, 1354, 2)

    # click select city
    tap(device, 724, 421, 1)

    # click city 2 - mumbai
    tap(device, 634, 1024)
    tap_phone_back(device)

    # back to util
    tap_phone_back(device)


def visit_holidays(device):
    print('\tvisit_holidays')

    # click side menu
    tap(device, 117, 170, 0)

    # click util
    tap(device, 355, 1674, 2)

    # swipe to the bottom of the page
    swipe(device, 500, 2000, 500, 100, 0)
    swipe(device, 500, 2000, 500, 100, 0)

    # click upcoming long weekend
    tap(device, 657, 2080)

    # back to util
    tap_phone_back(device)

    # click side menu
    tap(device, 117, 170, 0)

    # go to home page
    tap(device, 405, 661, 2)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('io.github.project_travel_mate') != -1:
        time.sleep(4)
        print('\tRunning interaction for TravelMate')
        # login(device)
        visit_delhi(device)
        # Travel mate stated to crash when visiting this activity
        # visit_mumbai_weather_via_utility(device)
        visit_holidays(device)
        visit_holidays(device)
    else:
        print('\tSkip file')
