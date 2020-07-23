import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back


def visit_subscriptions_and_podcasts(device):
    print('\tvisit_subscriptions')
    # side menu is already open on the first access

    # click in subscriptions
    tap(device, 427, 522, 1)

    # click add podcast
    tap(device, 225, 549, 1)

    # click search itunes
    tap(device, 567, 714, 6)

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

    # click on browse gpodder
    tap(device, 603, 1061, 6)

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

    # back subscriptions
    tap_phone_back(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('de.danoeh.antennapod.debug') != -1:
        print('\tRunning interaction for AntennaPod')
        visit_subscriptions_and_podcasts(device)
    else:
        print('\tSkip file')
