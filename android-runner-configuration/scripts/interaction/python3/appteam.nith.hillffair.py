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


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('appteam.nith.hillffair') != -1:
        print('Running interaction for Hillffair')