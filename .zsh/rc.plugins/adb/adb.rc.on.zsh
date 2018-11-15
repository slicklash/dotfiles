alias run-nexus5x='emulator -avd nexus5x -writable-system'

function adb-mod-host() {
  adb root
  adb remount
  adb push /etc/hosts.emulator /etc/hosts
  echo "Hosts file updated!"
}

function adb-port-forward() {
  sudo sysctl net.ipv4.ip_forward=1
  sudo iptables -t nat -A OUTPUT -p tcp -d 192.168.1.126 --dport 33443 -j REDIRECT
  sudo iptables -t nat -A OUTPUT -p tcp -d 192.168.1.126 --dport 33444 -j REDIRECT
  sudo iptables -t nat -L
}
