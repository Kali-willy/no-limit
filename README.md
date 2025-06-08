# Gaming Performance Boost Script

A cross-platform script that optimizes CPU and GPU settings for gaming performance on Linux, Windows, and macOS systems. Compatible with all laptop and PC models.

## Features

- Optimizes CPU governor settings
- Adjusts GPU performance modes
- Reduces system swappiness for better responsiveness
- Disables unnecessary background services
- Clears memory caches
- Includes automatic restore functionality

## Requirements

- Linux: Bash shell with root/sudo privileges
- Windows: Windows Subsystem for Linux (WSL) or a Bash-compatible shell like Git Bash
- macOS: Terminal with root/sudo privileges

## Installation

1. Download the script:
```
wget https://raw.githubusercontent.com/kali-willy/gaming-boost/main/boost_gaming.sh
```

2. Make it executable:
```
chmod +x boost_gaming.sh
```

## Usage

### Start Performance Boost

```
sudo ./boost_gaming.sh start
```

### Stop Performance Boost and Restore Settings

```
sudo ./boost_gaming.sh stop
```

### Show Help

```
./boost_gaming.sh help
```

## Warnings

- This script requires root/admin privileges to modify system settings
- Always use the stop command before shutting down your system
- Some optimizations may increase power consumption and heat generation
- Performance improvements will vary depending on your hardware

## Troubleshooting

If you encounter any issues:

1. Make sure you're running the script with proper privileges
2. Check that your system is compatible with the script
3. Run the stop command to restore default settings

## License

This script is provided as-is under the MIT License. 
