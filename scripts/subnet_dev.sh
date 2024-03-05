#!/usr/bin/env bash
# Navigate to your project directory
cd ../bittensor-subnet-template

# Install the bittensor-subnet-template python package
python -m pip install -e .

# Create a coldkey for the owner role
btcli wallet new_coldkey --wallet.name owner

# Set up the miner's wallets
btcli wallet new_coldkey --wallet.name miner
btcli wallet new_hotkey --wallet.name miner --wallet.hotkey default

# Set up the validator's wallets
btcli wallet new_coldkey --wallet.name validator
btcli wallet new_hotkey --wallet.name validator --wallet.hotkey default

# Get yourself some test tao
btcli wallet faucet --wallet.name owner --subtensor.chain_endpoint ws://127.0.0.1:9946 
btcli wallet faucet --wallet.name validator --subtensor.chain_endpoint ws://127.0.0.1:9946 

# Register a subnet
btcli subnet recycle_register --wallet.name miner --wallet.hotkey default --subtensor.chain_endpoint ws://127.0.0.1:9946

# Add stake to the validator
btcli stake add --wallet.name validator --wallet.hotkey default --subtensor.chain_endpoint ws://127.0.0.1:9946

# Ensure both the miner and validator keys are successfully registered.
btcli subnet list --subtensor.chain_endpoint ws://127.0.0.1:9946
btcli wallet overview --wallet.name validator --subtensor.chain_endpoint ws://127.0.0.1:9946
btcli wallet overview --wallet.name miner --subtensor.chain_endpoint ws://127.0.0.1:9946

# TODO: Send to tmux and open a 2-pane window
python neurons/miner.py --netuid 1 --subtensor.chain_endpoint ws://127.0.0.1:9946 --wallet.name miner --wallet.hotkey default --logging.debug
python neurons/validator.py --netuid 1 --subtensor.chain_endpoint ws://127.0.0.1:9946 --wallet.name validator --wallet.hotkey default --logging.debug

# Check if inside a tmux session
if [ -z "$TMUX" ]; then
    # Start a new tmux session and run the miner in the first pane
    tmux new-session -d -s bittensor -n 'miner' 'python neurons/miner.py --netuid 1 --subtensor.chain_endpoint ws://127.0.0.1:9946 --wallet.name miner --wallet.hotkey default --logging.debug'
    
    # Split the window and run the validator in the new pane
    tmux split-window -h -t bittensor:miner 'python neurons/validator.py --netuid 1 --subtensor.chain_endpoint ws://127.0.0.1:9946 --wallet.name validator --wallet.hotkey default --logging.debug'
    
    # Attach to the new tmux session
    tmux attach-session -t bittensor
else
    # If already in a tmux session, create two panes in the current window
    tmux split-window -h 'python neurons/miner.py --netuid 1 --subtensor.chain_endpoint ws://127.0.0.1:9946 --wallet.name miner --wallet.hotkey default --logging.debug'
    tmux split-window -v -t 0 'python neurons/validator.py --netuid 1 --subtensor.chain_endpoint ws://127.0.0.1:9946 --wallet.name validator --wallet.hotkey default --logging.debug'
fi
