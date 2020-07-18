from AndroidRunner.pyand import ADB
import time


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    #
    adb = ADB(adb_path='/home/sshann/Android/Sdk/platform-tools/adb')
    apps = [
        'org.quantumbadger.redreader'
    ]
    dbs = [
        'nappa.db',
        'nappa.db-shm',
        'nappa.db-wal',
    ]
    for app in apps:
        for db in dbs:
            result = adb.shell_command('run-as %s rm /data/data/%s/databases/%s' % (app, app, db))
            result = result.decode('utf-8') if (isinstance(result, bytes) == True) else result
            print("Deleting DB, app %s, file %s, result %s." % (app, db, result))
    pass
