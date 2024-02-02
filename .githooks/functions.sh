#!/bin/sh


# Check if Black is installed
check_black_installed() {
  if ! run black --version >/dev/null 2>&1; then
    print_in_box "Black is not installed." \
      "Run 'pip install black' to install it."
    exit 1
  fi
}

# Check if Pylint is installed
check_pylint_installed() {
  if ! run pylint --version >/dev/null 2>&1; then
    print_in_box "Pylint is not installed." \
      "Run 'pip install pylint' to install it."
    exit 1
  fi
}

# Check if Black formatting is correct on all staged .py files.
check_black_formating() {
  check_black_installed
  for file in $(git diff --cached --name-only | grep -E '\.py$'); do
      run black --check "$file"
      if [ $? -ne 0 ]; then
        echo "${file} is not formatted correctly. Run 'black ${file}' to fix the formatting."
        exit 1
      fi
  done
}

# Run Pylint with detailed message template on all staged .py files.
check_pylint_rules() {
  check_pylint_installed
  # Read ignore patterns from pylintrc
  IGNORE_PATTERNS=$(grep "îgnore-patterns" .pylintrc | cut -d= -f2 | tr ',' '\n')
  # Get a list of staged python files
  STAGED_FILES=$(git diff --cached --name-only '*.py')

  # Filter out files that match ignore patterns
  for file in $STAGED_FILES; do
    if echo "$file" | grep -E "$IGNORE_PATTERNS"; then
        continue
    fi

    pylint_output=$(pylint --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" "$file")
    exit_code=$?

    if [ $exit_code -ne 0 ]; then
      echo "$pylint_output"
      echo "linting error in $file"
      exit 1
    fi
  done
}

# Prevent commits to the default branches (development, production)
prevent_default_branch() {
  # Get the name of the current branch
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
    branch_name="(unnamed branch)" # detached HEAD
  branch_name=${branch_name##refs/heads/}

  # List of restricted branches
  restricted_branches="development production"

  # Check if current branch is one of the restricted branches
  for branch in $restricted_branches; do
    if [ "$branch_name" == "$branch" ]; then
      echo "Commits to $branch are not allowed."
      abort_with_message
    fi
  done
}

export -f check_black_formating
export -f check_pylint_rules
export -f prevent_default_branch
