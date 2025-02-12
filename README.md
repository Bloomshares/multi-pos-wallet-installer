# multi-pos-wallet-installer
# Auto Install Script for Multiple PoS Coins

## Overview
This repository contains an automated install script (`install_pos_coins.sh`) designed to set up and manage multiple Proof-of-Stake (PoS) coin wallets on a single Linux VPS. The script also facilitates the integration of these coins into the **Mintrax Exchange (https://mintrax.exchange)**.

## Features
- Automated installation and configuration of PoS coin wallets.
- Supports multiple PoS coins running simultaneously on a single VPS.
- Generates required configuration files (e.g., `.conf`, systemd service files).
- Enables seamless addition of new PoS coins.
- Integrates PoS coin wallets into Mintrax Exchange automatically.

## Requirements
- Linux-based VPS (Ubuntu 20.04+ recommended)
- Root or sudo access
- Git installed (`sudo apt install git -y`)

## Installation
1. **Clone the Repository**
   ```sh
   git clone https://github.com/Bloomshares/multi-pos-wallet-installer.git
   cd multi-pos-wallet-installer
   ```

2. **Grant Execution Permission**
   ```sh
   chmod +x install_pos_coins.sh
   ```

3. **Run the Installer**
   ```sh
   ./install_pos_coins.sh
   ```

4. **Follow the On-Screen Prompts**
   - Enter coin details (name, ticker, RPC port, etc.) as prompted.

## Adding a New PoS Coin
To add a new coin after the initial installation:
```sh
./install_pos_coins.sh add_coin
```
Follow the prompts to enter details for the new coin.

## Mintrax Exchange Integration
- The script automatically updates the **Mintrax Exchange** environment file (`exchange.env`) with the new coin's RPC details.
- It adds the coin to the Mintrax database for trading and wallet connectivity.

## Managing Wallets
- **Start a Wallet Daemon:**
  ```sh
  systemctl start COIN_TICKER.service
  ```
- **Stop a Wallet Daemon:**
  ```sh
  systemctl stop COIN_TICKER.service
  ```
- **Check Wallet Status:**
  ```sh
  systemctl status COIN_TICKER.service
  ```

## GitHub Contribution Guide
To contribute updates or modifications:
```sh
# Add all changes
git add .

# Commit changes
git commit -m "Updated install script for new coin support"

# Push to GitHub
git push origin main
```

## License
This project is licensed under the **MIT License**. See `LICENSE` for details.

## Contact
For support or inquiries, reach out via **[Mintrax Exchange](https://mintrax.exchange)** or open an issue on GitHub.

