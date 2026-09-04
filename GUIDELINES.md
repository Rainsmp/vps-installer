# TERMUX VPS INSTALLER
## User Guidelines

Welcome to Termux VPS Installer!

This project allows you to install and manage Linux distributions
inside Termux using proot-distro.

---

## REQUIREMENTS

Before using the installer, make sure you have:

- Android device
- Termux
- Internet connection
- Enough free storage
- A stable Wi-Fi/mobile-data connection

---

## INSTALLATION

Open Termux and run:

pkg update -y
pkg install -y curl

Then run:

bash <(curl -fsSL https://raw.githubusercontent.com/Rainsmp/vps-installer/main/install.sh)

The installer will automatically install the required packages
and open the VPS Manager.

---

## VPS MANAGER

The main menu contains:

[1] Delete VPS
[2] Reinstall VPS
[3] Create VPS
[4] Start VPS
[5] Restart VPS
[6] Stop VPS
[7] Enter VPS
[8] VPS Status
[9] Exit

---

## CREATE VPS

Select:

[3] Create VPS

Then select the Linux distribution you want to install.

Available distributions may include:

- Debian
- Ubuntu
- Alpine Linux
- Arch Linux
- Fedora
- openSUSE
- Void Linux
- Manjaro
- Artix Linux
- Deepin
- OpenKylin
- Pardus

Availability depends on your installed proot-distro version.

---

## ENTER VPS

Select:

[7] Enter VPS

This will open the selected Linux distribution.

Example:

root@localhost:~#

You can then use the Linux environment normally where supported.

---

## VPS STATUS

Select:

[8] VPS Status

Use this option to check information about your selected VPS.

---

## REINSTALL VPS

Select:

[2] Reinstall VPS

WARNING:

Reinstalling removes the existing Linux environment and its
files before installing it again.

Back up important files before reinstalling.

---

## DELETE VPS

Select:

[1] Delete VPS

WARNING:

Deleting a VPS removes the selected Linux environment and its files.

Make sure you have backed up anything important before deleting it.

---

## START / STOP / RESTART

The VPS uses proot-distro inside Termux.

Unlike a real cloud VPS, it does not run as a traditional
system service.

These options manage access to the Linux environment according
to the capabilities of the installer.

---

## IMPORTANT LIMITATIONS

This is NOT a real cloud VPS.

It runs Linux in Termux using proot-distro.

Because of this:

- It does not automatically provide a public IP address.
- Performance depends on your Android device.
- Android restrictions still apply.
- Some Linux software may not work.
- Kernel-level features may be unavailable.
- It is not equivalent to a real VPS provider.
- Long-running services may be affected by Android battery management.
- Available RAM and CPU depend on your device.

---

## UPDATING

If you already cloned the repository:

cd ~/vps-installer
git pull

Then start the manager:

./menu.sh

---

## TROUBLESHOOTING

If something does not work, check:

proot-distro --version

and:

proot-distro list

When asking for help, provide the complete error message.

Do NOT share:

- Passwords
- GitHub tokens
- SSH private keys
- API keys
- Other private credentials

---

## RESPONSIBLE USE

Use this project responsibly and only on devices and systems
you are authorized to use.

Do not use it to access, damage, disrupt, or interfere with
systems you do not own or have permission to use.

---

## PROJECT

GitHub:
https://github.com/Rainsmp/vps-installer

One-command installer:

bash <(curl -fsSL https://raw.githubusercontent.com/Rainsmp/vps-installer/main/install.sh)

---

## AUTHOR

Rainsmp

