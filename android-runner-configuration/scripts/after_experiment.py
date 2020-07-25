import subprocess


def uninstall_apps():
    treatments = [
        'baseline'
    ]
    packages = [
        'io.github.project_travel_mate'
    ]
    for treatment in treatments:
        for package in packages:
            app = '%s.%s' % (treatment, package)
            command = 'adb uninstall %s' % app
            subprocess.call(command, shell=True)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    uninstall_apps()
    pass
