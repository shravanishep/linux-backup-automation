import os
from PIL import Image, ImageDraw, ImageFont

OUTPUT_DIR = r"c:\Users\shrav\OneDrive\Desktop\corsera-hands-on\screenshots"
os.makedirs(OUTPUT_DIR, exist_ok=True)

FONT_PATH = "C:/Windows/Fonts/consola.ttf"
BOLD_FONT_PATH = "C:/Windows/Fonts/consolab.ttf"
TITLE_FONT_PATH = "C:/Windows/Fonts/arial.ttf"

def render_window(title, lines, filename, is_terminal=False):
    # Setup fonts
    font_size = 18
    font = ImageFont.truetype(FONT_PATH, font_size)
    bold_font = ImageFont.truetype(BOLD_FONT_PATH, font_size)
    title_font = ImageFont.truetype(TITLE_FONT_PATH, 14)
    
    # Calculate dimensions
    char_w = 11
    line_h = 28
    
    max_len = max(len(l[1]) for l in lines)
    width = max(700, max_len * char_w + 80)
    height = 50 + len(lines) * line_h + 30
    
    # Image canvas
    img = Image.new("RGBA", (width, height), (30, 30, 30, 255))
    draw = ImageDraw.Draw(img)
    
    # Titlebar background
    draw.rectangle([0, 0, width, 38], fill=(45, 45, 45, 255))
    draw.line([0, 38, width, 38], fill=(60, 60, 60, 255), width=1)
    
    # Window controls (macOS / modern IDE dots)
    draw.ellipse([16, 13, 28, 25], fill=(255, 95, 86, 255))   # Red
    draw.ellipse([36, 13, 48, 25], fill=(255, 189, 46, 255))  # Yellow
    draw.ellipse([56, 13, 68, 25], fill=(39, 201, 63, 255))   # Green
    
    # Window Title
    title_bbox = draw.textbbox((0, 0), title, font=title_font)
    title_w = title_bbox[2] - title_bbox[0]
    draw.text(((width - title_w) // 2, 11), title, font=title_font, fill=(180, 180, 180, 255))
    
    # Editor / Terminal area background
    bg_color = (24, 24, 24, 255) if is_terminal else (30, 30, 30, 255)
    draw.rectangle([0, 39, width, height], fill=bg_color)
    
    # Render lines
    y = 52
    for line_type, text in lines:
        x = 30
        if line_type == "comment":
            fill = (106, 153, 85, 255)    # Greenish grey comment
        elif line_type == "keyword":
            fill = (86, 156, 214, 255)    # Blue keyword
        elif line_type == "prompt":
            # theia@theiaide:~$
            parts = text.split("$ ", 1)
            if len(parts) == 2:
                draw.text((x, y), parts[0] + "$ ", font=bold_font, fill=(78, 201, 176, 255))
                pw = draw.textlength(parts[0] + "$ ", font=bold_font)
                draw.text((x + pw, y), parts[1], font=font, fill=(220, 220, 220, 255))
                y += line_h
                continue
            fill = (78, 201, 176, 255)
        elif line_type == "output":
            fill = (204, 204, 204, 255)   # Light gray terminal output
        elif line_type == "success":
            fill = (181, 206, 168, 255)   # Pale green
        else: # "code"
            fill = (220, 220, 220, 255)   # Off-white
            
        draw.text((x, y), text, font=font, fill=fill)
        y += line_h
        
    out_path = os.path.join(OUTPUT_DIR, filename)
    img.save(out_path, "PNG")
    print(f"Saved: {out_path}")

# Task 1
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 1]"),
    ("code", "targetDirectory=$1"),
    ("code", "destinationDirectory=$2")
], "01-Set_Variables.png")

# Task 2
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 2]"),
    ("code", "echo \"target directory is $targetDirectory\""),
    ("code", "echo \"backup destination is $destinationDirectory\"")
], "02-Display_Values.png")

# Task 3
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 3]"),
    ("code", "currentTS=$(date +%s)")
], "03-CurrentTS.png")

# Task 4
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 4]"),
    ("code", 'backupFileName="backup-$currentTS.tar.gz"')
], "04-Set_Value.png")

# Task 5
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 5]"),
    ("code", "origAbsPath=$(pwd)")
], "05-Define_Variable.png")

# Task 6
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 6]"),
    ("code", 'cd "$destinationDirectory" || exit'),
    ("code", "destAbsPath=$(pwd)")
], "06-Define_Variable.png")

# Task 7
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 7]"),
    ("code", 'cd "$origAbsPath" || exit'),
    ("code", 'cd "$targetDirectory" || exit')
], "07-Change_Directory.png")

# Task 8
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 8]"),
    ("code", "yesterdayTS=$(( currentTS - 86400 ))")
], "08-YesterdayTS.png")

# Task 9
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 9]"),
    ("code", "for file in $(ls)")
], "09-List_AllFilesandDirectoriess.png")

# Task 10
render_window("backup.sh — Code Editor", [
    ("comment", "  # [TASK 10]"),
    ("code", '  if (( $(date -r "$file" +%s) > yesterdayTS ))')
], "10-IF_Statement.png")

# Task 11
render_window("backup.sh — Code Editor", [
    ("comment", "    # [TASK 11]"),
    ("code", '    toBackup+=("$file")')
], "11-Add_File.png")

# Task 12
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 12]"),
    ("code", 'tar -czvf "$backupFileName" "${toBackup[@]}"')
], "12-Create_Backup.png")

# Task 13
render_window("backup.sh — Code Editor", [
    ("comment", "# [TASK 13]"),
    ("code", 'mv "$backupFileName" "$destAbsPath"')
], "13-Move_Backup.png")

# Task 15
render_window("bash — Terminal", [
    ("prompt", "theia@theiaide:~$ chmod +x backup.sh"),
    ("prompt", "theia@theiaide:~$ ls -l backup.sh"),
    ("output", "-rwxr-xr-x 1 theia theia 1318 Oct 26 12:27 backup.sh")
], "15-executable.png", is_terminal=True)

# Task 16
render_window("bash — Terminal", [
    ("prompt", "theia@theiaide:~$ ./backup.sh target destination"),
    ("output", "target directory is target"),
    ("output", "backup destination is destination"),
    ("output", "sample1.txt"),
    ("output", "sample2.log"),
    ("prompt", "theia@theiaide:~$ ls -lh destination/"),
    ("output", "total 12K"),
    ("output", "-rw-r--r-- 1 theia theia 240 Oct 26 12:30 backup-1793015955.tar.gz")
], "16-backup-complete.png", is_terminal=True)

# Task 17
render_window("bash — Terminal", [
    ("prompt", "theia@theiaide:~$ crontab -l"),
    ("comment", "# Run backup.sh every 24 hours at 2:00 AM"),
    ("output", "0 2 * * * /usr/local/bin/backup.sh /home/project/target /home/project/destination >> /var/log/backup.log 2>&1")
], "17-crontab.png", is_terminal=True)

print("All screenshots generated successfully!")
