import os
import subprocess
import json
import sys

def run_command(command):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    if process.returncode != 0:
        print(f"Error executing command: {command}")
        print(error.decode('utf-8'))
        sys.exit(1)
    return output.decode('utf-8')

def setup_environment(env_file):
    # Create and activate Conda environment
    run_command(f"conda env create -f {env_file}")
    env_name = get_env_name(env_file)
    run_command(f"conda activate {env_name}")

    # Get the path to the Python executable in the new environment
    python_path = run_command(f"conda run -n {env_name} where python").strip()

    # Update VSCode settings
    update_vscode_settings(python_path)

    print(f"Environment '{env_name}' has been created and configured for VSCode.")

def get_env_name(env_file):
    with open(env_file, 'r') as f:
        for line in f:
            if line.startswith('name:'):
                return line.split(':')[1].strip()
    raise ValueError("Environment name not found in the YAML file.")

def update_vscode_settings(python_path):
    vscode_settings_dir = os.path.join(os.getcwd(), '.vscode')
    os.makedirs(vscode_settings_dir, exist_ok=True)
    settings_file = os.path.join(vscode_settings_dir, 'settings.json')

    if os.path.exists(settings_file):
        with open(settings_file, 'r') as f:
            settings = json.load(f)
    else:
        settings = {}

    settings['python.pythonPath'] = python_path
    settings['python.defaultInterpreterPath'] = python_path

    with open(settings_file, 'w') as f:
        json.dump(settings, f, indent=4)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python setup_env.py <path_to_environment.yml>")
        sys.exit(1)

    env_file = sys.argv[1]
    setup_environment(env_file)