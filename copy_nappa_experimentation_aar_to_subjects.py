import os
import subprocess

aar_source_path = '/home/sshann/Documents/thesis/experiments/NappaExperimentation/app/build/outputs/aar/'
aar_original_name = 'app-debug.aar'
aar_new_name = 'nappa-experimentation.aar'

gradle_assemble_command = './gradlew assemble'
subprocess.call(gradle_assemble_command, shell=True)

os.replace(aar_source_path + aar_original_name, aar_source_path + aar_new_name)

destination_path_partial = '/home/sshann/Documents/thesis/subjects/'

treatments = [
    'baseline',
    'instrumented-nappa-greedy',
    'instrumented-nappa-tfpr',
    'instrumented-paloma',
    'perfect',
]

dirs_to_copy = [
    'AntennaPod/app/',
    'AntennaPod/core/',
    'Hillffair/app/',
    'materialistic/app/',
    'NewsBlur/clients/android/NewsBlur/',
    'RedReader/',
    'Travel-Mate/Android/app/',
    'uob-timetable-android/uob/uob-timetable/',
]

source_path = aar_source_path + aar_new_name
print('Copy AAR file from %s to' % source_path)
dir_not_found = []
for treatment in treatments:
    print('Tretament #%s' % treatment)
    for directory in dirs_to_copy:
        destination_path = destination_path_partial + treatment + '/' + directory
        if not os.path.isdir(destination_path):
            dir_not_found.append(destination_path)
            continue
        destination_path = destination_path + 'libs/aars/'
        mkdir_command = 'mkdir -p %s' % destination_path
        cp_command = 'yes | cp -rf %s %s' % (source_path, destination_path)
        print('- %s' % destination_path)
        subprocess.call(mkdir_command, shell=True)
        subprocess.call(cp_command, shell=True)
    print('')

print('Library Nappa')
nappa_path = '/home/sshann/Documents/thesis/NAPPA/Prefetching-Library/android_prefetching_lib/libs/aars/'
print('- %s' % nappa_path)
mkdir_command = 'mkdir -p %s' % nappa_path
cp_command = 'yes | cp -rf %s %s' % (source_path, nappa_path)

print('\nCould not find the directories:')
for directory in dir_not_found:
    print('- %s' % directory)
