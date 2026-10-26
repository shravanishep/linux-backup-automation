# Submission Evidence — Coursera Linux Backup Automation Final Project

This directory contains all required evidence files for the five Coursera graded tasks. All commands have been executed, validated, and verified on an Ubuntu Linux environment (via WSL 2).

## Evidence Files Summary

| Task | File Name | Description | Status |
|:---:|:---|:---|:---:|
| **Task 1** | [`backup-script-snippets.md`](backup-script-snippets.md) | Mapping of all 13 required code elements to exact lines in `backup.sh` | ✅ Verified Complete |
| **Task 2** | [`backup-permissions`](backup-permissions) | Execution permissions check (`chmod +x` and `ls -l`) | ✅ Verified Complete |
| **Task 3** | [`backup-file-check`](backup-file-check) | Execution of `backup.sh` and verification of generated `.tar.gz` archive | ✅ Verified Complete |
| **Task 4** | [`backup-script-copy`](backup-script-copy) | Installation of `backup.sh` to `/usr/local/bin/` with permissions check | ✅ Verified Complete |
| **Task 5** | [`crontab-schedule`](crontab-schedule) | Crontab daily schedule entry verification (`crontab -l`) | ✅ Verified Complete |

---

## Command Quick Reference

If you need to reproduce or re-run any evidence in your terminal:

```bash
# Task 2: Permissions
chmod +x backup.sh
ls -l backup.sh

# Task 3: Execute backup and check archive
./backup.sh tests/test-source tests/test-backups
ls -lh tests/test-backups/backup-*.tar.gz
tar -tf tests/test-backups/backup-*.tar.gz

# Task 4: Install to system bin
sudo install -m 755 backup.sh /usr/local/bin/backup.sh
ls -l /usr/local/bin/backup.sh

# Task 5: Crontab schedule (daily at 2:00 AM)
crontab -l
```
