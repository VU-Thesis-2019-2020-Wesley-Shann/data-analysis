file_dir = '/home/sshann/Documents/thesis/experiments/android-runner-configuration/scripts/interaction/'
file_name_list = [
    'org.quantumbadger.redreader',
    'com.ak.uobtimetable',
]
file_to_aggregate_list = {
    'com.ak.uobtimetable': [
        'com.ak.uobtimetable_cs_apprenticeship_digital_tec_year_1_september',
        'com.ak.uobtimetable_about',
        'com.ak.uobtimetable_check_CS_course_options',
        'com.ak.uobtimetable_cs_foundation_AI_year_0_february',
        'com.ak.uobtimetable_term_date',
    ],
    'org.quantumbadger.redreader': [
        'org.quantumbadger.redreader_announcement',
        'org.quantumbadger.redreader_ask_science',
        'org.quantumbadger.redreader_aww',
        'org.quantumbadger.redreader_front_page',
    ]
}

for file in file_name_list:
    files_to_aggregate = file_to_aggregate_list[file]
    dst_file_path = file_dir + 'monkey_recorder/nexus_5x' + file
    with open(dst_file_path, 'w') as outfile:
        for src_file in files_to_aggregate:
            src_file_path = file_dir + 'monkey_recorder/nexus_5x' + src_file
            with open(src_file_path) as infile:
                outfile.write(infile.read())
                outfile.write('\n')
