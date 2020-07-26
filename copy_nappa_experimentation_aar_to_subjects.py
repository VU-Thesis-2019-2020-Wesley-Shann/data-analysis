import os  
import subprocess

aar_source_path = '/home/sshann/Documents/thesis/experiments/NappaExperimentation/app/build/outputs/aar/'
aar_original_name = 'app-debug.aar'
aar_new_name = 'nappa-experimentation.aar'

gradle_assemble_command = './gradlew assemble'
subprocess.call(gradle_assemble_command, shell=True)

os.replace(aar_source_path + aar_original_name,aar_source_path + aar_new_name) 

destination_path_partial = '/home/sshann/Documents/thesis/subjects/'

treatments = [
    'baseline',
]

dirs_to_copy = [
    'AntennaPod/app/libs/aars/',
    'AntennaPod/core/libs/aars/',
    'Hillffair/app/libs/aars/',
    'materialistic/app/libs/aars/',
    'NewsBlur/clients/android/NewsBlur/libs/aars/',
    'RedReader/libs/aars/',
    'Travel-Mate/Android/app/libs/aars/',
    'uob-timetable-android/uob/uob-timetable/libs/aars/',
]

source_path = aar_source_path + aar_new_name
print('Copy AAR file from %s to' % source_path)
for treatment in treatments:
    for dir in dirs_to_copy:
        destination_path = destination_path_partial + treatment + '/' + dir
        mkdir_command = 'mkdir -p %s' % destination_path
        cp_command = 'yes | cp -rf %s %s' % (source_path, destination_path )
        print('- %s' % destination_path)
        subprocess.call(mkdir_command, shell=True)
        subprocess.call(cp_command, shell=True)

nappa_path = '/home/sshann/Documents/thesis/NAPPA/Prefetching-Library/android_prefetching_lib/libs/aars/'
print('- %s' % nappa_path)
mkdir_command = 'mkdir -p %s' % nappa_path
cp_command = 'yes | cp -rf %s %s' % (source_path, nappa_path )
