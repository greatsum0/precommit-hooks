## Setup Python Environment

All required dependencies can be found in `requirements.txt`.

For pip, you need to execute:

```shell
pip install -r requirements.txt
```

## Linting and Formatting

For maintaining code quality and consistency, use [pylint](https://pypi.org/project/pylint/) for linting and [`black`](https://pypi.org/project/black/) for formatting.

### Pre-commit Git Hooks

Enforce linting and formatting standards through pre-commit Git hooks. To activate these hooks, you need to execute:

```shell
git config --local core.hooksPath .githooks/
```

Make the file executable:

```shell
chmod +x .githooks/run_in_env.sh
```

### IDE Recommendations

- **VSCode**: Install the `Python` and `Pylint` extensions. For formatting with Black, install the `Black Formatter` extension.