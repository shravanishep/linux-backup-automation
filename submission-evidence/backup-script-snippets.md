# backup-script-snippets.md
# Coursera: Hands-on Introduction to Linux Commands and Shell Scripting
# IBM Final Project — Task 1 Evidence
# Maps all 13 assignment code requirements to exact lines in backup.sh

## The 13 Code Requirements (TASK 1–13)

---

### [TASK 1] — Check number of command-line arguments

**Requirement:** Validate that exactly two arguments are passed; exit with error if not.

```bash
if [[ $# != 2 ]]; then
    echo "ERROR: Invalid number of arguments."
    echo "Usage: ./backup.sh target_directory destination_directory"
    exit 1
fi
```

---

### [TASK 2] — Assign arguments to named variables

**Requirement:** Assign the first argument to `targetDirectory` and the second to `destinationDirectory`.

```bash
targetDirectory=$1
destinationDirectory=$2
```

---

### [TASK 3] — Display argument values

**Requirement:** Print the values of `targetDirectory` and `destinationDirectory` to confirm input.

```bash
echo "Target directory:      $targetDirectory"
echo "Destination directory: $destinationDirectory"
```

---

### [TASK 4] — Validate the target directory exists

**Requirement:** Check that `targetDirectory` is a real directory; exit with error if not.

```bash
if [[ ! -d "$targetDirectory" ]]; then
    echo "ERROR: Target directory '$targetDirectory' does not exist."
    exit 1
fi
```

---

### [TASK 5] — Capture current timestamp in seconds

**Requirement:** Define `currentTS` using `date +%s` to get epoch time.

```bash
currentTS=$(date +%s)
```

---

### [TASK 6] — Calculate yesterday's timestamp

**Requirement:** Define `yesterdayTS` as 86400 seconds (24 hours) before `currentTS`.

```bash
yesterdayTS=$(( currentTS - 86400 ))
```

---

### [TASK 7] — Define archive filename with timestamp

**Requirement:** Define `backupFileName` using `backup-<currentTS>.tar.gz` format.

```bash
backupFileName="backup-${currentTS}.tar.gz"
```

---

### [TASK 8] — Capture absolute path of destination directory

**Requirement:** Use `cd` + `pwd` to get the absolute path of the destination directory. Create it if needed.

```bash
mkdir -p "$destinationDirectory"
cd "$destinationDirectory" || { echo "ERROR: Cannot access destination."; exit 1; }
destAbsPath=$(pwd)
cd - > /dev/null || exit 1
```

---

### [TASK 9] — Change into the target directory

**Requirement:** `cd` into `targetDirectory` to iterate its files.

```bash
cd "$targetDirectory" || { echo "ERROR: Cannot access target '$targetDirectory'."; exit 1; }
```

---

### [TASK 10] — Loop through files in the target directory

**Requirement:** Use a `for` loop to iterate all items in the current (target) directory.

```bash
declare -a toBackup

for file in *; do
    if [[ -f "$file" ]]; then
        ...
    fi
done
```

---

### [TASK 11] — Compare file modification time to yesterdayTS

**Requirement:** Use `date -r` to get each file's modification timestamp and compare it to `yesterdayTS`. Include only recently modified files.

```bash
fileTS=$(date -r "$file" +%s 2>/dev/null)
if [[ -n "$fileTS" ]] && (( fileTS > yesterdayTS )); then
    toBackup+=("$file")
fi
```

---

### [TASK 12] — Create compressed tar archive of selected files

**Requirement:** Use `tar -czf` to create the backup archive from the `toBackup` array.

```bash
if [[ ${#toBackup[@]} -gt 0 ]]; then
    tar -czf "$backupFileName" "${toBackup[@]}"
```

---

### [TASK 13] — Move archive to destination directory

**Requirement:** Move the completed archive from the target directory to `destAbsPath`.

```bash
    mv "$backupFileName" "$destAbsPath/"
    echo "SUCCESS: Backup archive created → $destAbsPath/$backupFileName"
fi
```

---

## Summary Table

| Task | Variable / Command | Purpose |
|---|---|---|
| TASK 1 | `if [[ $# != 2 ]]` | Validate argument count |
| TASK 2 | `targetDirectory=$1` / `destinationDirectory=$2` | Assign arguments |
| TASK 3 | `echo "Target directory..."` | Display arguments |
| TASK 4 | `if [[ ! -d "$targetDirectory" ]]` | Validate source exists |
| TASK 5 | `currentTS=$(date +%s)` | Get current epoch timestamp |
| TASK 6 | `yesterdayTS=$(( currentTS - 86400 ))` | Calculate 24h-ago timestamp |
| TASK 7 | `backupFileName="backup-${currentTS}.tar.gz"` | Name the archive |
| TASK 8 | `cd $dest && destAbsPath=$(pwd)` | Capture absolute dest path |
| TASK 9 | `cd "$targetDirectory"` | Move to source directory |
| TASK 10 | `for file in *; do ... done` | Iterate target files |
| TASK 11 | `date -r "$file" +%s` vs `yesterdayTS` | Filter recent files |
| TASK 12 | `tar -czf "$backupFileName" ...` | Create tar.gz archive |
| TASK 13 | `mv "$backupFileName" "$destAbsPath/"` | Move archive to destination |
