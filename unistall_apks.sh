APPS=(
    # Baseline
    "baseline.io.github.project_travel_mate"
    "baseline.appteam.nith.hillffair"
    "baseline.com.newsblur"
    "baseline.io.github.hidroh.materialistic"
    "baseline.de.danoeh.antennapod.debug"
    "baseline.com.ak.uobtimetable"
    "baseline.org.quantumbadger.redreader"

    # Nappa Greedy
    "nappagreedy.io.github.project_travel_mate"
    "nappagreedy.appteam.nith.hillffair"
    "nappagreedy.com.newsblur"
    "nappagreedy.io.github.hidroh.materialistic"
    "nappagreedy.de.danoeh.antennapod.debug"
    "nappagreedy.com.ak.uobtimetable"
    "nappagreedy.org.quantumbadger.redreader"

    # Nappa TFPR
    "nappatfpr.io.github.project_travel_mate"
    "nappatfpr.appteam.nith.hillffair"
    "nappatfpr.com.newsblur"
    "nappatfpr.io.github.hidroh.materialistic"
    "nappatfpr.de.danoeh.antennapod.debug"
    "nappatfpr.com.ak.uobtimetable"
    "nappatfpr.org.quantumbadger.redreader"

    # PALOMA
    "paloma.io.github.project_travel_mate"
    "paloma.appteam.nith.hillffair"
    "paloma.com.newsblur"
    "paloma.io.github.hidroh.materialistic"
    "paloma.de.danoeh.antennapod.debug"
    "paloma.com.ak.uobtimetable"
    "paloma.org.quantumbadger.redreader"
)

echo "Uninstalling any apk left in the device" 
echo "Any app not installed will print Failure [DELETE_FAILED_INTERNAL_ERROR]"
count=0
for app in "${APPS[@]}"; do
    echo "- ${app}" 
    adb shell pm clear "${app}"
    adb uninstall "${app}"
    echo ""
done