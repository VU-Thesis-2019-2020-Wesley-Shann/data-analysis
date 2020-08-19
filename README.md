# Empirical Evaluation

This repository contains all files creates for or from the empirical evaluation of this thesis.

This repository is organized as follows:

| Directory                    | Description                                            |
|------------------------------|--------------------------------------------------------|
| NappaExperimentation         | Android library for logging statements                 |
| android-runner-configuration | AR configuration and extended Python scripts           |
| data-analysis                | R scripts and output                                   |
| experiment-results           | Raw and preprocessed data                              |
| mitmproxy-5.2-linux          | Proxy configuration, recorded flows and execution file |

The remaining files are scripts to automate the build of subjects APK files and output from the mobile device properties:

* `unistall_apks.sh`: Uninstall all subjects installed in the device. Used to quickly clean up the mobile device during the configuration and before running the experiment.
* `copy_nappa_experimentation_aar_to_subjects.py`: Update the AAR file from the NappaExperimentation library for all subjects
* `prepare_subjects_for_experiment.sh`: Contains a pipeline to import all libraries (NAPPA and NappaExperimentation), build APKs, move APKs to the central build directory and uninstall all leftover subjects from the mobile device.
* `device_dumpsys.txt` and `device_getprops.txt` are output from running the commands `adb dumpsys` and `adb getprops` for the mobile device used in the experiment.
