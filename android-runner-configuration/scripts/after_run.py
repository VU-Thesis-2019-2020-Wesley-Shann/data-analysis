import time


def close_app(device):
    print('close app')
    time.sleep(1)
    device.shell('input tap 1134 2469')
    time.sleep(2)
    device.shell('input tap 1246 1360')
    time.sleep(1)
    device.shell('input keyevent KEYCODE_BACK')


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    close_app(device)
    pass
