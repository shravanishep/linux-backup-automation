#!/bin/bash
# WSL test runner — writes all evidence to files
# Run via: wsl -d Ubuntu -- bash /mnt/c/Users/shrav/OneDrive/Desktop/corsera-hands-on/tests/wsl_run.sh

PROJ='/mnt/c/Users/shrav/OneDrive/Desktop/corsera-hands-on'
EVIDENCE="$PROJ/submission-evidence"
cd "$PROJ"

mkdir -p "$EVIDENCE"
mkdir -p tests/test-backups tests/test-source tests/test-empty

echo "=== STEP 1: Make executable ==="
chmod +x backup.sh
ls -l backup.sh | tee "$EVIDENCE/backup-permissions"

echo ""
echo "=== STEP 2: Syntax check ==="
bash -n backup.sh && echo "SYNTAX OK"

echo ""
echo "=== STEP 3: Setup test files ==="
rm -f tests/test-source/*
touch tests/test-source/recent_file_1.txt
touch tests/test-source/recent_file_2.log
echo "Hello backup" > "tests/test-source/recent with space.txt"
touch -d '2 days ago' tests/test-source/old_file_1.txt
touch -d '3 days ago' tests/test-source/old_file_2.conf
ls -la tests/test-source/

echo ""
echo "=== STEP 4: Run backup.sh ==="
rm -f tests/test-backups/backup-*.tar.gz
bash backup.sh tests/test-source tests/test-backups

echo ""
echo "=== STEP 5: List archive ==="
ls -lh tests/test-backups/backup-*.tar.gz | tee "$EVIDENCE/backup-file-check"

echo ""
echo "=== STEP 6: Check archive contents ==="
tar -tf tests/test-backups/backup-*.tar.gz

echo ""
echo "=== STEP 7: Install to /usr/local/bin ==="
sudo install -m 755 backup.sh /usr/local/bin/backup.sh
ls -l /usr/local/bin/backup.sh | tee "$EVIDENCE/backup-script-copy"

echo ""
echo "=== STEP 8: Setup crontab ==="
# Remove any existing backup.sh crontab entry, add new one
(crontab -l 2>/dev/null | grep -v backup.sh; echo "0 2 * * * /usr/local/bin/backup.sh /home/\$USER/source_backup /home/\$USER/backups >> /var/log/backup.log 2>&1") | crontab -
crontab -l | tee "$EVIDENCE/crontab-schedule"

echo ""
echo "=== ALL DONE ==="
echo "Evidence files written to: $EVIDENCE"
ls -la "$EVIDENCE/"
