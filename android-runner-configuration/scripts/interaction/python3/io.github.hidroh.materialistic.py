import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back


def visit_catching_up(device):
    print('\tvisit_catching_up')

    # open side menu
    tap(device, 90, 192, 0)

    # go to catching up
    tap(device, 432, 858)

    # click on first card
    tap(device, 724, 400, 8)

    # click on comments
    tap(device, 355, 693)

    # return to feed list
    tap_phone_back(device)

    # click on second card
    tap(device, 648, 789)

    # click on comments
    tap(device, 355, 693)

    # return to feed list
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)

    # open side menu
    tap(device, 90, 192, 0)

    # go to catching up
    tap(device, 432, 858)

    # click on first card
    tap(device, 724, 400)

    # return to feed list
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)


def visit_best_stories(device):
    print('\tvisit_best_stories')

    # open side menu
    tap(device, 90, 192, 0)

    # open more sections
    tap(device, 427, 1322, 1)

    # go to best stories
    tap(device, 567, 1562)

    # click on first card
    tap(device, 724, 400, 8)

    # click on comments
    tap(device, 355, 693)

    # return to feed list
    tap_phone_back(device)

    # click on second card
    tap(device, 648, 789)

    # click on comments
    tap(device, 355, 693)

    # return to feed list
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)

    # open side menu
    tap(device, 90, 192, 0)

    # this is kept open
    # # open more sections
    # tap(device, 427, 1322, 1)

    # go to best stories
    tap(device, 567, 1562)

    # click on first card
    tap(device, 724, 400)

    # return to feed list
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('io.github.hidroh.materialistic') != -1:
        print('\tRunning interaction for Materialistic')
        # visit_catching_up(device)
        visit_best_stories(device)
    else:
        print('\tSkip file')
