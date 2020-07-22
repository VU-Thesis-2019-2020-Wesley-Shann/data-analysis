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
