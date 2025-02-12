#!/bin/bash

# Auto Install Script for Running Multiple PoS Coins on a Single VPS
# Author: Equitichain
# Version: 1.0

# ================================
# ✅ Step 1: VPS Setup (Updates, Firewall, Swap)
# ================================
setup_vps() {
    echo "🔄 Updating system and installing dependencies..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install ufw fail2ban htop unzip curl jq -y

    echo "🔐 Setting up firewall..."
    sudo ufw allow ssh
    sudo ufw enable

    echo "💾 Checking and setting up swap..."
    if ! grep -q "swapfile" /etc/fstab; then
        sudo fallocate -l 4G /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    fi
}

# ================================
# ✅ Step 2: Install a New PoS Coin Wallet
# ================================
install_coin() {
    echo "📥 Enter Coin Name (e.g., Cryptoshares):"
    read COIN_NAME
    echo "🔠 Enter Coin Ticker (e.g., SHARES):"
    read COIN_TICKER
    echo "🔗 Enter Wallet Daemon Download URL:"
    read WALLET_URL
    echo "🌐 Enter RPC Port (must be unique for each coin):"
    read RPC_PORT

    # Define paths
    COIN_DIR="$HOME/$COIN_NAME"
    CONF_DIR="$HOME/.$COIN_TICKER"
    CONF_FILE="$CONF_DIR/$COIN_TICKER.conf"
    
    echo "🚀 Installing $COIN_NAME ($COIN_TICKER)..."

    # Create directories
    mkdir -p $COIN_DIR $CONF_DIR

    # Download wallet daemon
    cd $COIN_DIR
    wget $WALLET_URL -O ${COIN_TICKER}d
    chmod +x ${COIN_TICKER}d

    # Create Configuration File
    echo "📄 Creating config file..."
    RPC_USER="${COIN_TICKER}rpc"
    RPC_PASS="$(openssl rand -base64 32)"
    
    cat <<EOF > $CONF_FILE
rpcuser=$RPC_USER
rpcpassword=$RPC_PASS
rpcallowip=127.0.0.1
rpcport=$RPC_PORT
listen=1
server=1
staking=1
daemon=1
logtimestamps=1
EOF

    echo "🛠️ Setting up systemd service..."
    SERVICE_FILE="/etc/systemd/system/${COIN_TICKER}.service"

    cat <<EOF | sudo tee $SERVICE_FILE
[Unit]
Description=$COIN_NAME Wallet
After=network.target

[Service]
User=root
Group=root
ExecStart=$COIN_DIR/${COIN_TICKER}d -daemon
ExecStop=$COIN_DIR/${COIN_TICKER}d stop
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    # Enable and Start the Service
    sudo systemctl daemon-reload
    sudo systemctl enable ${COIN_TICKER}.service
    sudo systemctl start ${COIN_TICKER}.service

    echo "✅ $COIN_NAME ($COIN_TICKER) installed successfully!"
    echo "Use 'systemctl status ${COIN_TICKER}.service' to check status."
}

# ================================
# ✅ Step 3: Add More Coins Later
# ================================
add_more_coins() {
    echo "➕ Adding a new PoS Coin..."
    install_coin
}

# ================================
# ✅ Main Script Execution
# ================================
if [[ $1 == "add_coin" ]]; then
    add_more_coins
else
    echo "🚀 Starting Multi-PoS Coin Installer..."
    setup_vps
    install_coin
    echo "🎉 Installation Complete! Use './install_pos_coins.sh add_coin' to add more coins later."
fi
