
#!/bin/bash
set -euo pipefail

cd /app

echo "=========================="
echo "Executing todo.py"
echo "=========================="

python3 .github/scripts/todo.py | tee todo_output.txt

echo "=========================="
echo "Executing todo-test.py"
echo "=========================="

python3 .github/scripts/todo-test.py | tee test_output.txt

echo "=========================="
echo "Updating index.html"
echo "=========================="

bash .github/scripts/update_index.sh \
    todo_output.txt \
    test_output.txt

echo "=========================="
echo "Done!"
echo "=========================="