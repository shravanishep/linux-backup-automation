# Linux Backup Automation — Final Project
## Coursera: Hands-on Introduction to Linux Commands and Shell Scripting (IBM)

---

## Project Purpose

Automatically back up files modified within the last 24 hours from a specified source directory into a compressed, timestamped archive saved in a destination directory.

---

## Features

- Accepts source and destination directories as command-line arguments
- Archives only files modified in the **last 24 hours**
- Timestamped archive name: `backup-<epoch>.tar.gz`
- Creates destination directory if it does not exist
- Validates arguments and source directory before running
- Handles empty file sets gracefully (no error, just an info message)
- Reports success or failure clearly
- Safe for scheduling with cron

---

## Requirements

- **OS:** Linux or macOS (Windows: use WSL 2 with Ubuntu)
- **Shell:** Bash 4+
- **Utilities:** `tar`, `date`, `find`, `mv`, `mkdir` (all standard on Ubuntu)
- **Permissions:** Write access to destination directory; `sudo` to install to `/usr/local/bin/`

---

## Project Structure

```
linux-backup-automation/
├── README.md
├── backup.sh                        # Main backup script
├── .gitignore
├── submission-evidence/
│   ├── README.md
│   ├── backup-script-snippets.md    # 13 task requirements mapped to code
│   ├── backup-permissions           # chmod + ls -l evidence
│   ├── backup-file-check            # ls -lh of generated archive
│   ├── backup-script-copy           # ls -l /usr/local/bin/backup.sh evidence
│   └── crontab-schedule             # crontab -l output
└── tests/
    ├── run_tests.sh                 # Automated test runner
    └── test_data/                   # Sample files for testing
```

---

## Configuration

The script is configured entirely via command-line arguments:

```bash
./backup.sh <targetDirectory> <destinationDirectory>
```

| Argument | Description |
|---|---|
| `targetDirectory` | Directory whose recently-modified files will be backed up |
| `destinationDirectory` | Directory where the `.tar.gz` archive will be saved |

---

## Make the Script Executable

```bash
chmod +x backup.sh
ls -l backup.sh
```

---

## Run the Script Manually

```bash
./backup.sh /path/to/source /path/to/backups
```

**Example (test data):**

```bash
./backup.sh ~/test-source ~/test-backups
```

---

## Verify the Archive

```bash
ls -lh ~/test-backups/
tar -tf ~/test-backups/backup-*.tar.gz
```

---

## Install to /usr/local/bin/

This makes the script available system-wide and is required for cron:

```bash
sudo install -m 755 backup.sh /usr/local/bin/backup.sh
ls -l /usr/local/bin/backup.sh
```

---

## Schedule with Cron (Daily at 2 AM)

```bash
crontab -e
```

Add this line:

```
0 2 * * * /usr/local/bin/backup.sh /path/to/source /path/to/backups >> /var/log/backup.log 2>&1
```

Verify:

```bash
crontab -l
```

---

## Inspect Cron Output / Troubleshoot

```bash
# View backup log (if cron logging is configured)
cat /var/log/backup.log

# Check cron service status
systemctl status cron

# Check syslog for cron entries
grep CRON /var/log/syslog | tail -20
```

---

## Coursera Evidence Files

| Task | Evidence File | Description |
|---|---|---|
| Task 1 | `submission-evidence/backup-script-snippets.md` | 13 code requirements mapped to backup.sh |
| Task 2 | `submission-evidence/backup-permissions` | chmod + ls -l output |
| Task 3 | `submission-evidence/backup-file-check` | ls -lh of archive |
| Task 4 | `submission-evidence/backup-script-copy` | ls -l /usr/local/bin/backup.sh |
| Task 5 | `submission-evidence/crontab-schedule` | crontab -l output |
