def clear_cache_redeader(device):
    device.shell(
        'run-as %s rm /data/data/%s/databases/cache.db' % (device.current_activity(), device.current_activity()))
    print('\tat "/data/data/%s/databases/cache.db"' % device.current_activity())

    device.shell('run-as %s rm /data/data/%s/databases/cache.db-journal' % (
        device.current_activity(), device.current_activity()))
    print('\tat "/data/data/%s/databases/cache.db-journal"' % device.current_activity())


def clear_cache_uob(device):
    device.shell(
        'run-as %s rm /data/data/%s/shared_prefs/prefs.xml' % (device.current_activity(), device.current_activity()))
    print('\tat "/data/data/%s/shared_prefs/prefs.xml"' % device.current_activity())


def clear_cache_dir(device):
    print('\tat "/data/data/%s/cache/"' % device.current_activity())
    result = device.shell(
        'run-as %s rm -rf /data/data/%s/cache/' % (device.current_activity(), device.current_activity()))


def clear_cache(device):
    print('clearing app cache')
    clear_cache_dir(device)
    if device.current_activity().find('org.quantumbadger.redreader') != -1:
        clear_cache_redeader(device)
    elif device.current_activity().find('com.ak.uobtimetable') != -1:
        clear_cache_uob(device)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    clear_cache(device)
    pass
