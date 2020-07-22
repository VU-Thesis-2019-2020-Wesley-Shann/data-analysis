import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import tap
from scripts.interaction.python3.common import tap_phone_back


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('com.newsblur') != -1:
        print('\tRunning interaction for NewsBlur')
    else:
        print('\tSkip file')
