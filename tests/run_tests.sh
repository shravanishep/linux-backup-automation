#!/bin/bash

##############################################################################
# run_tests.sh — Test runner for backup.sh
# Usage: bash tests/run_tests.sh
##############################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_SCRIPT="$SCRIPT_DIR/backup.sh"
TEST_SOURCE="$SCRIPT_DIR/tests/test-source"
TEST_DEST="$SCRIPT_DIR/tests/test-backups"
PASS=0
FAIL=0

green() { echo -e "\033[0;32m✔ $*\033[0m"; }
red()   { echo -e "\033[0;31m✘ $*\033[0m"; }

echo "═══════════════════════════════════════"
echo "  backup.sh Test Suite"
echo "═══════════════════════════════════════"

# ── Setup ────────────────────────────────────
rm -rf "$TEST_SOURCE" "$TEST_DEST"
mkdir -p "$TEST_SOURCE" "$TEST_DEST"

# Create RECENT files (modified now → should be backed up)
touch "$TEST_SOURCE/recent_file_1.txt"
touch "$TEST_SOURCE/recent_file_2.log"
echo "Hello backup" > "$TEST_SOURCE/recent_with_space in name.txt"

# Create OLD files (modified >24h ago → should NOT be backed up)
touch -d "2 days ago" "$TEST_SOURCE/old_file_1.txt"
touch -d "3 days ago" "$TEST_SOURCE/old_file_2.conf"

echo ""
echo "Test data:"
ls -la "$TEST_SOURCE/"

# ── Syntax check ─────────────────────────────
echo ""
echo "TEST 1: Bash syntax check"
if bash -n "$BACKUP_SCRIPT"; then
    green "PASS — bash -n reports no syntax errors"
    (( PASS++ ))
else
    red "FAIL — syntax errors found in backup.sh"
    (( FAIL++ ))
fi

# ── Wrong argument count ──────────────────────
echo ""
echo "TEST 2: Script rejects wrong argument count"
if bash "$BACKUP_SCRIPT" 2>&1 | grep -q "Usage"; then
    green "PASS — script printed Usage when called with no args"
    (( PASS++ ))
else
    red "FAIL — script did not reject wrong argument count"
    (( FAIL++ ))
fi

# ── Invalid source directory ──────────────────
echo ""
echo "TEST 3: Script rejects invalid source directory"
if bash "$BACKUP_SCRIPT" /nonexistent_dir_xyz "$TEST_DEST" 2>&1 | grep -q "ERROR"; then
    green "PASS — script reported ERROR for missing source"
    (( PASS++ ))
else
    red "FAIL — script did not handle missing source directory"
    (( FAIL++ ))
fi

# ── Normal backup run ─────────────────────────
echo ""
echo "TEST 4: Normal backup run — recent files only"
OUTPUT=$(bash "$BACKUP_SCRIPT" "$TEST_SOURCE" "$TEST_DEST" 2>&1)
echo "$OUTPUT"

ARCHIVE=$(ls "$TEST_DEST"/backup-*.tar.gz 2>/dev/null | head -1)
if [[ -n "$ARCHIVE" ]]; then
    green "PASS — archive created: $(basename "$ARCHIVE")"
    (( PASS++ ))
else
    red "FAIL — no archive was created"
    (( FAIL++ ))
fi

# ── Archive name format ───────────────────────
echo ""
echo "TEST 5: Archive filename format"
if [[ "$(basename "$ARCHIVE")" =~ ^backup-[0-9]+\.tar\.gz$ ]]; then
    green "PASS — archive name matches backup-<timestamp>.tar.gz"
    (( PASS++ ))
else
    red "FAIL — archive name does not match expected format"
    (( FAIL++ ))
fi

# ── Archive contents ──────────────────────────
echo ""
echo "TEST 6: Archive contains recent files (not old files)"
CONTENTS=$(tar -tf "$ARCHIVE")
echo "Archive contents:"
echo "$CONTENTS"

if echo "$CONTENTS" | grep -q "recent_file_1.txt" && \
   echo "$CONTENTS" | grep -q "recent_file_2.log" && \
   echo "$CONTENTS" | grep -q "recent_with_space"; then
    green "PASS — recent files are in archive"
    (( PASS++ ))
else
    red "FAIL — recent files missing from archive"
    (( FAIL++ ))
fi

if echo "$CONTENTS" | grep -q "old_file_1" || echo "$CONTENTS" | grep -q "old_file_2"; then
    red "FAIL — old files should NOT be in archive"
    (( FAIL++ ))
else
    green "PASS — old files correctly excluded from archive"
    (( PASS++ ))
fi

# ── Empty selection (no recent files) ─────────
echo ""
echo "TEST 7: Empty source (no recently modified files)"
EMPTY_SRC="$SCRIPT_DIR/tests/test-empty"
mkdir -p "$EMPTY_SRC"
touch -d "2 days ago" "$EMPTY_SRC/old_only.txt"

OUTPUT2=$(bash "$BACKUP_SCRIPT" "$EMPTY_SRC" "$TEST_DEST" 2>&1)
echo "$OUTPUT2"
if echo "$OUTPUT2" | grep -q "No files modified"; then
    green "PASS — script handled empty set gracefully"
    (( PASS++ ))
else
    red "FAIL — script did not handle empty file set properly"
    (( FAIL++ ))
fi

# ── ls -lh of archive ────────────────────────
echo ""
echo "TEST 8: Archive listing (evidence for backup-file-check)"
ls -lh "$TEST_DEST"/backup-*.tar.gz

# ── Summary ───────────────────────────────────
echo ""
echo "═══════════════════════════════════════"
echo "  Results: $PASS passed, $FAIL failed"
echo "═══════════════════════════════════════"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
