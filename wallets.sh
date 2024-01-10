#!/bin/bash

# Function to create a cold wallet
create_cold_wallet() {
    read -p "Enter a name for the cold wallet: " COLD
    btcli w new_coldkey --wallet.name $COLD --no_password --subtensor.network finney --no_prompt
}

# Function to create hot wallets
create_hot_wallets() {
    read -p "Enter the number of hot wallets to create: " num_hot_wallets

    for ((i=1; i<=$num_hot_wallets; i++)); do
        HName="$i"
        btcli w new_hotkey --wallet.name $COLD --wallet.hotkey $i --subtensor.network finney --no_prompt
    done
}

# Function to show wallet list
show_wallet_list() {
    echo "Show Created Wallets:"
    btcli w list
}

# Redirect output to WALLETBACKUPS file
exec > >(tee -a $COLD_WALLETBACKUPS)

# Main script

# Create cold wallet
create_cold_wallet

# Create hot wallets
create_hot_wallets

# Show wallet list
show_wallet_list

echo "Cold and hot wallets created successfully."
