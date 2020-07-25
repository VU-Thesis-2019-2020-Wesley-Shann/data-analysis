import sys

sys.path.insert(0, '/home/sshann/Documents/thesis/experiments/android-runner-configuration/')

from scripts.interaction.python3.common import close_app


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    close_app(device)
    pass
