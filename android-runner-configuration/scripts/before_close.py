def clear_redreader_cache(device):
    device.shell(
        'run-as %s rm /data/data/%s/databases/cache.db' % (device.current_activity(), device.current_activity()))
    print('\tat"/data/data/%s/databases/cache.db"' % device.current_activity())

    device.shell('run-as %s rm /data/data/%s/databases/cache.db-journal' % (
        device.current_activity(), device.current_activity()))
    print('\tat"/data/data/%s/databases/cache.db-journal"' % device.current_activity())


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    print('clearing app cache')
    print('\tat"/data/data/%s/cache/"' % device.current_activity())
    result = device.shell(
        'run-as %s rm -rf /data/data/%s/cache/' % (device.current_activity(), device.current_activity()))
    if device.current_activity().find('org.quantumbadger.redreader') == -1:
        clear_redreader_cache(device)
    print('result is', result)
    pass
