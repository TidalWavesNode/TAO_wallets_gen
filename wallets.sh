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
        HName="hotwallet_$i"
        btcli w new_hotkey --wallet.name $COLD --wallet.hotkey $HName --subtensor.network finney --no_prompt
    done
}

# Function to show wallet list
show_wallet_list() {
    echo "Current Wallets:"
    btcli w list
}

# Function to register hot wallets
register_hot_wallets() {
    read -p "Do you want to start the registration script? (yes/no): " start_registration
    if [ "$start_registration" == "yes" ]; then
        read -p "Enter netuid: " SN

        for ((i=1; i<=$num_hot_wallets; i++)); do
            HName="$i"
            btcli s register --netuid $SN --wallet.name $COLD --wallet.hotkey $HName --subtensor.network finney --no_prompt
            sleep 10
        done
    else
        echo "Registration script not started."
    fi
}

# Redirect output to WALLETBACKUPS file
exec > >(tee -a WALLETBACKUPS)

# Main script

# Create cold wallet
create_cold_wallet

# Create hot wallets
create_hot_wallets

# Show wallet list
show_wallet_list

# Register hot wallets
register_hot_wallets

echo "Cold wallet and hot wallets created successfully."
