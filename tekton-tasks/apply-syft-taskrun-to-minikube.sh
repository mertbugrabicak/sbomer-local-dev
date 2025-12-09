#!/usr/bin/env bash

# Hacky script to apply syft-generator taskrun to minikube

REPO_URL="https://github.com/sbomer-project/syft-generator"
REPO_DIR="syft-generator"
SCRIPT_PATH="./hack/apply-syft-taskrun-to-minikube.sh"

# 1. Clone the repository
echo "Cloning repository: $REPO_URL"
if git clone $REPO_URL; then
    echo "Cloning complete."
else
    echo "Error: Failed to clone the repository. Exiting."
    exit 1
fi

# Go into the cloned directory
if cd $REPO_DIR; then
    echo "Successfully moved into $REPO_DIR."
else
    echo "Error: Failed to change directory to $REPO_DIR. Exiting."
    # Attempt to clean up the cloned directory before exiting
    cd .. 2>/dev/null
    rm -rf $REPO_DIR 2>/dev/null
    exit 1
fi

# 3. Run the script inside the repository
echo "Executing script: $SCRIPT_PATH"
if bash $SCRIPT_PATH; then
    echo "Script execution complete."
else
    echo "Warning: Script execution failed (check the output above for details)."
    # Decide whether to exit here or continue with cleanup. 
    # For simplicity, we will continue with cleanup.
fi

# 4. Remove the repository (move back to parent directory first)
echo "Returning to parent directory for cleanup."
cd ..

echo "Removing repository directory: $REPO_DIR"
# Use 'rm -rf' for recursive and forced deletion of the directory and its contents
if rm -rf $REPO_DIR; then
    echo "Repository removed successfully."
else
    echo "Error: Failed to remove the repository directory. Manual cleanup may be required."
    exit 1
fi

echo "Process finished. Successfully applied syft generation task yaml to minikube"