#!/bin/bash
set -e

TODO_OUTPUT="$1"
TEST_OUTPUT="$2"

python3 - "$TODO_OUTPUT" "$TEST_OUTPUT" <<'PY'
import sys
import re
import html
from pathlib import Path

task_text = Path(sys.argv[1]).read_text()
test_text = Path(sys.argv[2]).read_text()
html_file = Path("index.html")

todo_section = task_text.split("ToDo Tasks:", 1)[1]
todo_section, done_section = todo_section.split("Done Tasks:", 1)

content = html_file.read_text()

sections = {
    "pending": todo_section.strip(),
    "completed": done_section.strip(),
    "unittest": test_text.strip()
}

for section_id, text in sections.items():
    pattern = (
        rf'(<pre id="{section_id}">)'
        rf'.*?'
        rf'(</pre>)'
    )

    replacement = lambda match: (
        match.group(1)
        + "\n"
        + html.escape(text)
        + "\n"
        + match.group(2)
    )

    content, count = re.subn(
        pattern, replacement, content, flags=re.DOTALL
    )

    if count != 1:
        raise RuntimeError(
            f"Could not find pre section: {section_id}"
        )

html_file.write_text(content)
print("index.html updated successfully")
PY