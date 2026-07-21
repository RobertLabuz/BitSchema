# Easy start: https://github.com/casey/just/blob/master/README.md#shell
# To check available recipes, type just -l


[windows]
set shell := ["powershell.exe", "-NoLogo", "-Command"]


hello:
    Write-Host "Hello, world! Type just -l to list recipes"

# Initialize uv workspace. Install additional tools and dependencies
init:
    uv sync --all-extras

# Check, raise on format errors
lint flags='':
    uv run ruff format --diff ./tests/py ./packages # Whitespace check and suggestion
    uv run ruff check ./tests/py ./packages {{flags}} # Code check like unused imports

# Check with flag --output-format=github
lint_github: (lint "--output-format=github")

# Format Python code
format_py:
    uv run ruff check --select I --fix ./tests/py ./packages # Sort imports (removing unused needs --unsafe-fixes)
    uv run ruff format ./tests/py ./packages # Format code

# For more information, see https://mypy.readthedocs.io/
typecheck:
    uv run python -m mypy ./tests/py  
    uv run python -m mypy ./packages/bitschema/src --strict
    uv run python -m mypy ./packages/bitschema/tests # Relaxed for tests 

# Run Python unit tests
test_py_units:
    uv run python -m pytest -v ./packages
    
# Run Python and C integration tests
test_integration:
    # TODO: build C code
    uv run python -m pytest -v ./tests/py/integration

reinstall_packages:
    uv pip install -e ./packages/bitschema

# Format, lint, and typecheck shortcut 
format_and_check: format_py lint typecheck

# Reinstall packages and run all tests
test_all: reinstall_packages test_py_units test_integration

git_update_submodules:
    git submodule update --init --recursive

cmake_flags := '-G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++'

cpp_test_example:
    cmake -S tests/cpp/examples/full_build -B tests/cpp/examples/full_build/build {{cmake_flags}}
    cmake --build tests/cpp/examples/full_build/build
    ctest --test-dir tests/cpp/examples/full_build/build --output-on-failure
    