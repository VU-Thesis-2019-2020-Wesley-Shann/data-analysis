# Update Nappa library

zsh /home/sshann/Documents/thesis/subjects/update-nappa-library.sh

# Update experimentation library

cd "/home/sshann/Documents/thesis/experiments/NappaExperimentation/"
python3 /home/sshann/Documents/thesis/experiments/copy_nappa_experimentation_aar_to_subjects.py

# Assemble apks

zsh /home/sshann/Documents/thesis/subjects/assemble-apks.sh

# Copy apks to build dir

zsh /home/sshann/Documents/thesis/subjects/move-apks2.sh

# Uninstall apps in the device and clear user data

zsh /home/sshann/Documents/thesis/experiments/unistall_apks.sh
