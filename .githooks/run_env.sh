#!/bin/bash

# Set the virtual environment name
VENV_NAME=".venv"

# Check the operating system
if [[ "$OSTYPE" == "darwin"* || "$OSTYPE" == "linux-gnu"* ]]; then
    # macOS or Linux
    source "$VENV_NAME/bin/activate"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows
    source "$VENV_NAME/Scripts/activate"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Execute the remaining command
"$@"
