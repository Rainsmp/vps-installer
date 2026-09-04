#!/data/data/com.termux/files/usr/bin/bash

clear

printf '\033[36m╔══════════════════════════════════════════════╗\033[0m\n'
printf '\033[36m║              PUBLIC CONNECTION              ║\033[0m\n'
printf '\033[36m╚══════════════════════════════════════════════╝\033[0m\n\n'

printf '\033[32m[+] Starting SSH server...\033[0m\n'
sshd

printf '\033[32m[✓] SSH server started on port 8022.\033[0m\n'
printf '\033[33m[+] Starting Pinggy tunnel...\033[0m\n\n'

ssh -p 443 -R0:127.0.0.1:8022 tcp@free.pinggy.io
