import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back


def configure_settings(device):
    print('\tconfigure_settings')

    # open side menu
    tap(device, 103, 192, 0)

    # Click settings
    tap(device, 324, 2298, 1)

    # Click network settings
    tap(device, 400, 997, 0)

    # Click update interval or time of day
    tap(device, 697, 656, 0)

    # Click disable
    tap(device, 256, 1589, 0)

    # Return to settings
    tap_phone_back(device)

    # Return to front page
    tap_phone_back(device)


def visit_add_podcast_itunes(device):
    print('\tvisit_add_podcast_itunes')

    # open side menu
    # tap(device, 1233, 1274, 1)
    tap(device, 103, 192, 1)

    # # click in subscriptions
    # tap(device, 427, 522, 1)

    # # click add podcast from subscriptions
    # tap(device, 225, 549, 1)

    # click add podcast from side menu
    tap(device, 409, 1034, 1)

    # click search itunes
    tap(device, 567, 714, 6)

    # click card 1
    tap(device, 616, 469)
    # Subscribe to podcast 1
    tap(device, 625, 832)
    tap_phone_back(device)

    # click card 2
    tap(device, 639, 762)
    # Subscribe to podcast 2
    tap(device, 693, 821)
    tap_phone_back(device)

    # click card 2
    tap(device, 639, 762)
    tap_phone_back(device)

    # click card 1
    tap(device, 616, 469, 8)
    tap_phone_back(device)

    # back to add podcast
    tap_phone_back(device)

    # click search itunes
    tap(device, 567, 714, 6)

    # click card 1
    tap(device, 616, 469)
    tap_phone_back(device)

    # back to add podcast
    tap_phone_back(device, 1)


def visit_podcast(device):
    print('\tvisit_podcast')

    # open side menu
    tap(device, 103, 192, 1)

    # click in podcast from side menu
    tap(device, 625, 1248)

    # click in podcast configuration
    tap(device, 1363, 517)
    tap_phone_back(device)

    # click in podcast info
    tap(device, 1372, 384)
    tap_phone_back(device)

    # click in podcast item
    tap(device, 733, 896)
    tap_phone_back(device)


def visit_add_podcast_gpodder(device):
    print('\tvisit_add_podcast_gpodder')

    # open side menu
    tap(device, 103, 192, 1)

    # click add podcast from side menu
    tap(device, 409, 1034, 1)

    # click on browse gpodder
    tap(device, 603, 1061, 6)

    # click card 1
    tap(device, 526, 597)
    tap_phone_back(device)

    # click card 1
    tap(device, 526, 597)
    tap_phone_back(device)

    # back to add podcast
    tap_phone_back(device)

    # click on browse gpodder
    tap(device, 603, 1061, 6)

    # click card 1
    tap(device, 526, 597)
    tap_phone_back(device)

    # back to add podcast
    tap_phone_back(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('de.danoeh.antennapod.debug') != -1:
        time.sleep(4)
        run_antenna_pod_interaction(device)
    else:
        print('\tSkip file')


def run_antenna_pod_interaction(device):
    print('\tRunning interaction for AntennaPod')
    tap(device, 1233, 1274, 1)
    configure_settings(device)
    visit_add_podcast_itunes(device)
    visit_podcast(device)
    visit_add_podcast_gpodder(device)
