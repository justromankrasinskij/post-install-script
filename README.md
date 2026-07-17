# post-install-script

I wrote this script to automate initial setup of Debian 13. It's simple but useful for me. What is it do?

**Step 1.** Change some GRUB settings for faster start of system.

**Step 2.** Change a locale file to set 24-hour time format.

**Step 3.** Change APT sources.list from default to Latvian (they're faster for me).

**Step 4.** Set Fira Mono font as a default monospace font.

**Step 5.** Create a custom environment file with Qt rounding policy option to avoid blur of icons on HiDPI displays.

**Step 6.** Remove some unnecessary packages.

**Step 7.** Clean a current user's home directory with the exception of some files.

**Step 8.** Install a slightly modified Breeze theme without shadows of the panel.