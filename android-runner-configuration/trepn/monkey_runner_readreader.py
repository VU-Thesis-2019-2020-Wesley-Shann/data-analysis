from com.android.monkeyrunner import MonkeyRunner, MonkeyDevice


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    raise Exception("Sorry, no numbers below zero")
    print('=Runner RedReader start=')
    device = MonkeyRunner.waitForConnection()
    MonkeyRunner.sleep(2)
    device.touch(279, 1045, MonkeyDevice.DOWN_AND_UP)
    MonkeyRunner.sleep(10)
    print('=Runner RedReader end=')
