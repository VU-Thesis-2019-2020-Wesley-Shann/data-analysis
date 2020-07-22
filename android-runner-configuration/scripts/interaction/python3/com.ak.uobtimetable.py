import time


def tap(device, x, y, sleep=4):
    device.shell('input tap %s %s' % (x, y))
    time.sleep(sleep)


def swipe(device, x1, y1, x2, y2, sleep=4, duration=1000):
    device.shell('input swipe %s %s %s %s %s' % (x1, y1, x2, y2, duration))
    time.sleep(sleep)


def tap_phone_back(device, sleep=1):
    device.shell('input tap 324 2464')
    time.sleep(sleep)


def tap_continue_button(device):
    tap(device, 711, 1664, 6)


def tap_accept_course(device):
    tap(device, 1197, 1456)


def tap_menu(device):
    tap(device, 81, 176, 1)


def visit_courses_page(device):
    tap_menu(device)
    tap(device, 436, 1770, 6)


def swipe_weekday_to_left(device):
    swipe(device, 364, 368, 1012, 378, 1)


def tap_tuesday(device):
    swipe_weekday_to_left(device)
    tap(device, 409, 357, 1)


def tap_to_close_schedule_dialog(device):
    tap(device, 1192, 1520, 1)


def tap_second_option_in_schedule(device):
    tap(device, 364, 656, 2)
    tap_to_close_schedule_dialog(device)


def tap_dropdown_school(device):
    tap(device, 558, 368, 1)


def select_school_cs(device):
    tap_dropdown_school(device)
    tap(device, 945, 1376, 1)


def tap_dropdown_courses(device):
    tap(device, 481, 544, 1)


def select_courses_foundation(device):
    tap_dropdown_courses(device)
    tap(device, 310, 906, 1)


def select_course_bedfordshire_first_time(device):
    print('select_course_bedfordshire_first_time')
    # select course
    tap(device, 526, 704, 1)
    tap_accept_course(device)
    # close dialogs
    tap(device, 1215, 1450, 1)
    tap(device, 1215, 1482, 1)
    tap_tuesday(device)
    tap_second_option_in_schedule(device)


def select_course_ai(device):
    print('select_course_AI')
    visit_courses_page(device)
    select_school_cs(device)
    select_courses_foundation(device)
    # select course
    tap(device, 648, 709, 1)
    tap_accept_course(device)
    tap_tuesday(device)
    tap_second_option_in_schedule(device)


def visit_term_date(device):
    print('visit_term_date')
    tap_menu(device)
    tap(device, 360, 1098)


# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    if device.current_activity().find('com.ak.uobtimetable') != -1:
        print('Running interaction for UOB')
        tap_continue_button(device)
        select_course_bedfordshire_first_time(device)
        select_course_ai(device)
        visit_term_date(device)
    else:
        print('Skip file')
