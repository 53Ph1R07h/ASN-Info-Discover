# ⚡ GetAsnDetails.sh — **ASN Recon Toolkit**

```
	__| |___________________________________________________________________________________| |__
				__   ___________________________________________________________________________________   __
				  | |                                                                                   | |  
				  | |                                                                                   | |  
				  | |                                                                                   | |  
				  | |    ______  ________ _______  __    __ ______ _______   ______ ________ __    __   | |  
				  | |   /      \|        |       \|  \  |  |      |       \ /      |        |  \  |  \  | |  
				  | |  |  $$$$$$| $$$$$$$| $$$$$$$| $$  | $$\$$$$$| $$$$$$$|  $$$$$$\$$$$$$$| $$  | $$  | |  
				  | |  | $$___\$| $$__   | $$__/ $| $$__| $$ | $$ | $$__| $| $$  | $$ | $$  | $$__| $$  | |  
				  | |   \$$    \| $$  \  | $$    $| $$    $$ | $$ | $$    $| $$  | $$ | $$  | $$    $$  | |  
				  | |   _\$$$$$$| $$$$$  | $$$$$$$| $$$$$$$$ | $$ | $$$$$$$| $$  | $$ | $$  | $$$$$$$$  | |  
				  | |  |  \__| $| $$_____| $$     | $$  | $$_| $$_| $$  | $| $$__/ $$ | $$  | $$  | $$  | |  
				  | |   \$$    $| $$     | $$     | $$  | $|   $$ | $$  | $$\$$    $$ | $$  | $$  | $$  | |  
				  | |    \$$$$$$ \$$$$$$$$\$$      \$$   \$$\$$$$$$\$$   \$$ \$$$$$$   \$$   \$$   \$$  | |  
				  | |                                                                                   | |  
				  | |                                                                                   | |  
				__| |___________________________________________________________________________________| |__
				__   ___________________________________________________________________________________   __
				  | |                                                                                   | |  
  Lightweight ASN discovery — fast, scriptable, hacker-friendly.
```

[![Shellcheck](https://img.shields.io/badge/shell--check-passed-brightgreen)](https://www.shellcheck.net)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Dependencies](https://img.shields.io/badge/deps-curl%20%7C%20jq%20%7C%20dig-orange)](#installation)

---

> **What this does** — Resolve domains -> extract IP -> lookup ASN -> print the first IPv4 prefix + ASN description. Designed for recon, triage, and automation.

---

## 🚀 Quickstart

1. Ensure deps:

```bash
sudo apt update && sudo apt install -y curl jq dnsutils
```

2. Make executable:

```bash
chmod +x GetAsnDetails.sh
```

3. Run it:

```bash
# file input
./GetAsnDetails.sh domains.txt

# or via pipe
cat domains.txt | ./GetAsnDetails.sh
```

---

## 🧰 Visual, hacker-style Usage & Examples

### Example input (`domains.txt`)
```
example.com
google.com
unknown-domain.local
```

### Example output (human-friendly)
```
example.com  : 93.184.216.0/24    Edgecast Networks, Inc.
google.com   : 172.217.0.0/16     Google LLC
❌ unknown-domain.local -> Failed to resolve IP
❌ mystery.com -> ASN not found for 203.0.113.5
```

> Tip: pipe into `tee results.txt` to keep a log while you watch stdout.

---

## ✨ Features (at-a-glance)
- Minimal, portable: **Bash + curl + jq + dig**
- Accepts **file** or **stdin** input
- Clear success and error messages (stderr used for failures)
- Ideal for ad-hoc recon, automation in scripts, or building into larger toolchains

---

## 🧩 Output formats (human-first)
The tool prints `domain: <prefix> <description>` for each domain. For failed domains it prints descriptive error lines to stderr so you can separate success and failure streams:

```bash
# save success lines and failures separately
./GetAsnDetails.sh domains.txt 2>failures.log | tee success.log
```

---

## 🛠️ Troubleshooting
- **Empty output** — check that `domains.txt` contains one domain per line and no trailing spaces.
- **`dig` not found** — install `dnsutils` (Debian/Ubuntu).
- **API failures** — script uses `https://api.bgpview.io` — check network or API rate limits.

---

## 🧠 Recon Tips & Tricks
- Combine with `massdns`/`subfinder` to turn subdomain lists into AS maps.
- Use `xargs -P` to parallelize many domains (careful with API rate limits):

```bash
cat domains.txt | xargs -P8 -I{} sh -c 'echo {}; echo {} | ./GetAsnDetails.sh' 
```

- Grep for interesting providers:

```bash
./GetAsnDetails.sh domains.txt | grep -Ei "Google|Amazon|Cloudflare|Akamai"
```

---

## 🧾 Example workflow (recon)
1. Discover subdomains (subfinder, amass)
2. Resolve unique domains into `domains.txt`
3. Run `GetAsnDetails.sh` to get ASN mapping
4. Pivot to ASN ranges for additional scanning or targeting

---

## ⚠️ Notes & Considerations
- This tool returns the **first IPv4 prefix** reported by BGPView for simplicity. ASNs often announce many prefixes — use the API manually if you need all of them.
- The script intentionally prints errors to stderr so automation can filter or log them separately.
- The output is designed to be easy to parse by other scripts or tools.

---

## 🧾 License
MIT — steal, fix, and share. Patch back if you make wild improvements.

---

## ✍️ Credits & Contact
Made by **sephiroth** — contributions welcome. Open an issue or PR on the repository.


---
