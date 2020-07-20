file_dir = '/home/sshann/Documents/thesis/experiments/android-runner-configuration/scripts/interaction/'
file_name_list = [
    'org.quantumbadger.redreader'
]

template_line = '{"type": "touch", "x": %s, "y": %s, "down": %s, "up": %s, "sleep": 4 }\n'

for file in file_name_list:
    src_file_path = file_dir + 'monkey_recorder/' + file
    dst_file_path = file_dir + file
    dst_file = open(dst_file_path, 'w+')
    with open(src_file_path) as fp:
        line = fp.readline()
        down_count = 0
        up_count = 1
        cnt = 1
        while line:
            print("Line {}: {}".format(cnt, line.strip()))
            x = line.split('\'x\':')[1].split(',')[0]
            y = line.split('\'y\':')[1].split(',')[0]
            print('y', y)
            print('x', x)
            parsed_line = template_line % (x, y, down_count, up_count)
            down_count += 2
            up_count += 2
            dst_file.write(parsed_line)
            line = fp.readline()
            cnt += 1

    dst_file.close()
