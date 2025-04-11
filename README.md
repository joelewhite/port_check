---
tags: [port_scan, bash, networking, tools]
alias: [port_check, bash scanner]
created: 2025-04-11
---

# 🛡️ Port Check Utility (`port_check.sh`)

A lightweight Bash-only TCP/UDP port scanner using `/dev/tcp` and `/dev/udp`.

## ✅ Features
- ✅ No external dependencies (no `nmap`, `netcat`, etc.)
- ✅ TCP and UDP support
- ✅ Color-coded output
- ✅ Logs to plaintext and CSV
- ✅ `--quiet` mode for background/cron usage
- ✅ Systemd and Docker ready
- ✅ Available as `.deb`, AppImage, Snap, and PyPI wrapper

## 🚀 Usage

```bash
./port_check.sh --hosts "example.com" [--ports "22,443"] [--udp] [--log logfile] [--quiet]
```

## 🧰 Options

| Option       | Description                                                  |
|--------------|--------------------------------------------------------------|
| `--hosts`    | **Required.** Comma/space-separated hostnames or IPs         |
| `--ports`    | Optional. Default: `22, 80, 443, 8080, 8443`                 |
| `--udp`      | Use UDP instead of TCP                                       |
| `--log`      | Log to plaintext file, generates CSV beside it               |
| `--quiet`    | Suppress terminal output (requires `--log`)                  |
| `--help`     | Show built-in help                                           |

## 🧪 Examples

- Basic TCP scan:
  ```bash
  ./port_check.sh --hosts "example.com"
  ```

- Custom ports:
  ```bash
  ./port_check.sh --hosts "example.com" --ports "21,22,80,443"
  ```

- UDP scan:
  ```bash
  ./port_check.sh --hosts "dns.server.com" --ports "53,161" --udp
  ```

- Logging + silent run:
  ```bash
  ./port_check.sh --hosts "host1" --log results.txt --quiet
  ```

## 📦 Install Methods

- Manual:
  ```bash
  cp port_check.sh /usr/local/bin/port_check
  chmod +x /usr/local/bin/port_check
  ```

- Debian:
  ```bash
  sudo dpkg -i port_check_1.0.deb
  ```

- Docker:
  ```bash
  docker run --rm -e HOSTS="host1" -e PORTS="22,443" yourdockerhub/port_check
  ```

## 📁 Output

- **Plaintext log:**
  ```
  [2025-04-11 10:25:30] TCP Port 22 is OPEN
  ```

- **CSV log:**
  ```csv
  "Timestamp","Host","Port","Protocol","Status"
  "2025-04-11 10:25:30","example.com","22","TCP","OPEN"
  ```

## 📄 License

MIT  
Author: Joel E. White
