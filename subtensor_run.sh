 #!/usr/bin/env bash

# Update your shell's source to include Cargo's path
source "$HOME/.cargo/env"

# Update to the nightly version of rust
./scripts/init.sh

# Build the binary with faucet enabled
cargo build --release --features pow-faucet

# Initialize your local subtensor chain in development mode. This command will set up and run a local subtensor network.
# Run this in the background (or send to tmux/forked shell?)

# Check if inside a tmux session
# Start a new tmux session and create a new pane, but do not switch to it
tmux new-session -d -s localnet -n 'script' 'BUILD_BINARY=0; bash ./scripts/localnet.sh'
# Notify the user
echo "localnet.sh is running in a detached tmux session named 'localnet'"
echo "You can attach to this session with: tmux attach-session -t localnet"


