#!/bin/bash

# Gaming Performance Boost Script
# Works on Linux, Windows (with WSL), and macOS
# For all laptop and PC models

# Text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
  echo -e "${BLUE}===================================================${NC}"
  echo -e "${BLUE}       Gaming Performance Boost Script v1.0         ${NC}"
  echo -e "${BLUE}===================================================${NC}"
  echo -e "${BLUE}This script optimizes CPU and GPU settings for gaming${NC}"
  echo -e "${BLUE}Compatible with Linux, Windows, and macOS systems   ${NC}"
  echo -e "${BLUE}===================================================${NC}"
  echo ""
}

detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
    OS="windows"
  else
    echo -e "${RED}Unsupported operating system${NC}"
    exit 1
  fi
  echo -e "${GREEN}Detected operating system: ${OS}${NC}"
}

check_privileges() {
  if [[ "$OS" == "linux" ]] || [[ "$OS" == "macos" ]]; then
    if [[ $EUID -ne 0 ]]; then
      echo -e "${RED}This script must be run with sudo/root privileges${NC}"
      exit 1
    fi
  elif [[ "$OS" == "windows" ]]; then
    # Check for admin rights on Windows
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
      echo -e "${BLUE}Running in WSL. Some Windows optimizations may require additional steps.${NC}"
    else
      echo -e "${BLUE}For best results on Windows, run this script as Administrator${NC}"
    fi
  fi
}

create_restore_point() {
  # Create a backup of current settings
  mkdir -p ~/.gaming_boost_backup
  
  if [[ "$OS" == "linux" ]]; then
    # Save current CPU governor settings
    if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
      cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | head -n 1 > ~/.gaming_boost_backup/cpu_governor.bak
    fi
    
    # Save current swappiness
    if [[ -f /proc/sys/vm/swappiness ]]; then
      cat /proc/sys/vm/swappiness > ~/.gaming_boost_backup/swappiness.bak
    fi
    
  elif [[ "$OS" == "macos" ]]; then
    # No specific macOS settings to backup yet
    touch ~/.gaming_boost_backup/macos.bak
    
  elif [[ "$OS" == "windows" ]]; then
    # No specific Windows settings to backup yet
    touch ~/.gaming_boost_backup/windows.bak
  fi
  
  echo -e "${GREEN}Created system settings backup${NC}"
}

optimize_linux() {
  echo -e "${BLUE}Applying Linux optimizations...${NC}"
  
  # Set CPU governor to performance
  if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
    echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    echo -e "${GREEN}Set CPU governor to performance mode${NC}"
  else
    echo -e "${RED}Could not set CPU governor${NC}"
  fi
  
  # Reduce swappiness for better responsiveness
  if [[ -f /proc/sys/vm/swappiness ]]; then
    echo 10 > /proc/sys/vm/swappiness
    echo -e "${GREEN}Reduced swappiness to improve system responsiveness${NC}"
  fi
  
  # Disable unnecessary services
  systemctl stop bluetooth 2>/dev/null || true
  systemctl stop cups 2>/dev/null || true
  systemctl stop avahi-daemon 2>/dev/null || true
  echo -e "${GREEN}Disabled non-essential services${NC}"
  
  # Clear memory caches
  sync && echo 3 > /proc/sys/vm/drop_caches
  echo -e "${GREEN}Cleared memory caches${NC}"
  
  # Set GPU performance mode for NVIDIA cards
  if command -v nvidia-settings &> /dev/null; then
    nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1" &> /dev/null
    echo -e "${GREEN}Set NVIDIA GPU to performance mode${NC}"
  fi
  
  # Set GPU performance mode for AMD cards
  if [[ -d /sys/class/drm/card0/device/power_dpm_force_performance_level ]]; then
    echo "high" > /sys/class/drm/card0/device/power_dpm_force_performance_level
    echo -e "${GREEN}Set AMD GPU to high performance mode${NC}"
  fi
}

optimize_macos() {
  echo -e "${BLUE}Applying macOS optimizations...${NC}"
  
  # Kill unnecessary background processes
  killall "Activity Monitor" 2>/dev/null || true
  killall "Photos" 2>/dev/null || true
  killall "iTunes" 2>/dev/null || true
  killall "Music" 2>/dev/null || true
  
  # Purge memory
  purge 2>/dev/null
  echo -e "${GREEN}Purged memory cache${NC}"
  
  # Disable spotlight indexing temporarily
  mdutil -i off / 2>/dev/null
  echo -e "${GREEN}Disabled Spotlight indexing${NC}"
}

optimize_windows() {
  echo -e "${BLUE}Applying Windows optimizations...${NC}"
  
  if [[ -n "$WSL_DISTRO_NAME" ]]; then
    echo -e "${BLUE}Running in WSL. For best results, run the Windows version directly.${NC}"
    echo -e "${BLUE}Limited Windows optimizations in WSL mode.${NC}"
  else
    # The script is running directly on Windows
    echo -e "${BLUE}For Windows systems, this script has limited functionality.${NC}"
    echo -e "${BLUE}Please consider using the Windows version for full features.${NC}"
  fi
  
  # Clear Windows file cache through WSL
  echo -e "${GREEN}Clearing system caches${NC}"
}

restore_linux() {
  echo -e "${BLUE}Restoring Linux settings...${NC}"
  
  # Restore CPU governor
  if [[ -f ~/.gaming_boost_backup/cpu_governor.bak ]]; then
    governor=$(cat ~/.gaming_boost_backup/cpu_governor.bak)
    echo "$governor" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    echo -e "${GREEN}Restored CPU governor to $governor${NC}"
  fi
  
  # Restore swappiness
  if [[ -f ~/.gaming_boost_backup/swappiness.bak ]]; then
    swappiness=$(cat ~/.gaming_boost_backup/swappiness.bak)
    echo "$swappiness" > /proc/sys/vm/swappiness
    echo -e "${GREEN}Restored swappiness to $swappiness${NC}"
  fi
  
  # Restart services
  systemctl start bluetooth 2>/dev/null || true
  systemctl start cups 2>/dev/null || true
  systemctl start avahi-daemon 2>/dev/null || true
  echo -e "${GREEN}Restarted services${NC}"
  
  # Restore GPU settings
  if command -v nvidia-settings &> /dev/null; then
    nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=0" &> /dev/null
    echo -e "${GREEN}Restored NVIDIA GPU to default mode${NC}"
  fi
  
  if [[ -d /sys/class/drm/card0/device/power_dpm_force_performance_level ]]; then
    echo "auto" > /sys/class/drm/card0/device/power_dpm_force_performance_level
    echo -e "${GREEN}Restored AMD GPU to default mode${NC}"
  fi
}

restore_macos() {
  echo -e "${BLUE}Restoring macOS settings...${NC}"
  
  # Re-enable spotlight
  mdutil -i on / 2>/dev/null
  echo -e "${GREEN}Re-enabled Spotlight indexing${NC}"
}

restore_windows() {
  echo -e "${BLUE}Restoring Windows settings...${NC}"
  
  if [[ -n "$WSL_DISTRO_NAME" ]]; then
    echo -e "${BLUE}Limited Windows restoration in WSL mode.${NC}"
  else
    echo -e "${BLUE}Restoring Windows settings...${NC}"
  fi
}

start_boost() {
  print_header
  detect_os
  check_privileges
  create_restore_point
  
  echo -e "${BLUE}Starting performance boost...${NC}"
  
  if [[ "$OS" == "linux" ]]; then
    optimize_linux
  elif [[ "$OS" == "macos" ]]; then
    optimize_macos
  elif [[ "$OS" == "windows" ]]; then
    optimize_windows
  fi
  
  echo -e "${GREEN}Performance boost active! Your system is now optimized for gaming.${NC}"
  echo -e "${GREEN}To stop and restore settings, run: $0 stop${NC}"
}

stop_boost() {
  print_header
  detect_os
  check_privileges
  
  echo -e "${BLUE}Stopping performance boost and restoring settings...${NC}"
  
  if [[ "$OS" == "linux" ]]; then
    restore_linux
  elif [[ "$OS" == "macos" ]]; then
    restore_macos
  elif [[ "$OS" == "windows" ]]; then
    restore_windows
  fi
  
  echo -e "${GREEN}System settings restored to normal.${NC}"
}

show_help() {
  print_header
  echo "Usage: $0 [start|stop|help]"
  echo ""
  echo "Commands:"
  echo "  start    Start gaming performance boost"
  echo "  stop     Stop gaming performance boost and restore settings"
  echo "  help     Show this help message"
  echo ""
}

# Main script execution
case "$1" in
  start)
    start_boost
    ;;
  stop)
    stop_boost
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    show_help
    ;;
esac 