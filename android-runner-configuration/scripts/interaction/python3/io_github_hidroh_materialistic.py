import sys
import time

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back
from scripts.interaction.python3.common import write_text


def visit_catching_up(device):
    print('\tvisit_catching_up')

    # open side menu
    tap(device, 90, 192, 0)

    # go to catching up
    tap(device, 432, 858)

    # click on first card
    tap(device, 724, 400, 6)

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

    # click on second card
    tap(device, 648, 789)

    # click on comments
    tap(device, 355, 693)

    # return to feed list
    tap_phone_back(device)

    # click on first card
    tap(device, 724, 400)

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

    # click on second card
    tap(device, 648, 789)

    # click on comments
    tap(device, 355, 693)

    # return to feed list
    tap_phone_back(device)

    # click on first card
    tap(device, 724, 400, 8)

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


def visit_new_stories_from_saved(device):
    print('\tvisit_new_stories_from_saved')

    # open side menu
    tap(device, 90, 192, 0)

    # go to saved
    tap(device, 432, 1541, 2)

    # open side menu
    tap(device, 90, 192, 0)

    # go to new stories
    tap(device, 396, 1082, 1)

    # filter search
    tap(device, 1219, 165, 0)
    write_text(device, 'neptunia')
    tap(device, 1314, 2245)

    # click on the last visible card
    tap(device, 589, 2138)

    # click on comments
    tap(device, 355, 693)

    # return to filter feed list
    tap_phone_back(device)

    # close keyboard
    tap_phone_back(device)

    # return to feed list
    tap_phone_back(device)

    # return to saved paged
    tap_phone_back(device)

    # return to front page
    tap_phone_back(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('io.github.hidroh.materialistic') != -1:
        time.sleep(4)
        run_materialistic_interaction(device)
    else:
        print('\tSkip file')


def run_materialistic_interaction(device):
    print('\tRunning interaction for Materialistic')
    visit_catching_up(device)
    # This interaction works, but it duplicated the runtime for this app =/
    # visit_new_stories_from_saved(device)
    # visit_new_stories_from_saved(device)
    visit_best_stories(device)
