import os

TYPE_NUMBER = 1
TYPE_STRING = 2
TYPE_BOOLEAN = 3


def get_subject_base_path(exp):
    base_dir = '/home/sshann/Documents/thesis/experiments/android-runner-configuration/output/%s/data/nexus6p/' % exp
    return [base_dir + s for s in os.listdir(base_dir)]


def get_logcat_property(line, property_to_get):
    # print('1', line)
    idx = line.find(property_to_get) + len(property_to_get)
    property_value = line[idx:]
    # print('2', property_value)

    idx = property_value.find('=\'') + 2
    property_value = property_value[idx:]
    # print('3', property_value)

    idx = property_value.find(',') - 1
    property_value = property_value[:idx]
    # print('4', property_value)

    return property_value


def parse_logcat_to_csv(exp, tag, properties):
    print('parse_logcat_to_csv')
    subject_paths = get_subject_base_path(exp)
    for subject_path in subject_paths:
        subject = subject_path.split('/')
        print('\tParsing subject', subject[len(subject) - 1])
        base_path = subject_path + '/logcat/'
        for filename in os.listdir(base_path):
            if '.txt' not in filename:
                continue
            print('\t\tParsing file', filename)
            line_count = 0
            parsed_line_count = 0
            with open(os.path.join(base_path, filename), 'r') as src_file:
                dst_file_name = '%s%s/%s' % (base_path, tag, filename.replace('.txt', '.csv'))
                os.makedirs(os.path.dirname(dst_file_name), exist_ok=True)
                with open(dst_file_name, 'w') as dst_file:
                    line = src_file.readline()
                    csv_header = ','.join(properties.keys()) + '\n'
                    dst_file.write(csv_header)
                    while line:
                        line_count = line_count + 1
                        # print('\t\t\t raw line %s' % line)
                        if tag in line:
                            parsed_line_count = parsed_line_count + 1
                            properties_values = []
                            for property_label, property_type in properties.items():
                                property_value = get_logcat_property(line, property_label)
                                if property_type == TYPE_STRING:
                                    property_value = '"%s"' % property_value
                                properties_values.append(property_value)
                            csv_line = ','.join(properties_values) + '\n'
                            # print('\t\t\tparsed line %s' % csv_line)
                            dst_file.write(csv_line)
                        line = src_file.readline()
            print('\t\tParsed %s lines from %s' % (parsed_line_count, line_count))


def main():
    print('preprocess_logcat')
    exps = [
        '2020.07.27_204222'
    ]
    for exp in exps:
        network_duration = {
            "REQUEST_DURATION_SYSTEM": TYPE_NUMBER,
            "REQUEST_DURATION_OKHTTP": TYPE_NUMBER,
            "REQUEST_SYNCHRONOUS": TYPE_BOOLEAN,
            "RESPONSE_CODE": TYPE_NUMBER,
            "RESPONSE_METHOD": TYPE_STRING,
            "RESPONSE_LENGTH_OKHTTP": TYPE_NUMBER,
            "RESPONSE_LENGTH_HEADER": TYPE_NUMBER,
            "REQUEST_PROTOCOL": TYPE_STRING,
            "REQUEST_URL": TYPE_STRING,
        }
        parse_logcat_to_csv(exp, 'MetricNetworkRequestExecutionTime', network_duration)

        if 'nappa' in exp:
            strategy_duration = {
                "STRATEGY_CLASS": TYPE_STRING,
                "DURATION": TYPE_NUMBER,
                "NUMBER_OF_URLS": TYPE_NUMBER,
            }
            parse_logcat_to_csv(exp, 'MetricNappaPrefetchingStrategyExecutionTime', strategy_duration)


if __name__ == "__main__":
    main()
