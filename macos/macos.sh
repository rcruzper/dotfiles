#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

info 'Setting up osx (It will restart Dock and Finder)'

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# iCloud Documents is the default directory opened in the fileviewer dialog when saving a new document
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Fix Mojave font for Non-Retina displays
# defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Set a really fast key repeat.
# It is not working now
#defaults write NSGlobalDomain KeyRepeat -int 2
#defaults write NSGlobalDomain InitialKeyRepeat -int 25

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

defaults write com.apple.finder ShowRecentTags -bool false

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Set search scope.
# This Mac       : `SCev`
# Current Folder : `SCcf`
# Previous Scope : `SCsp`
defaults write com.apple.finder FXDefaultSearchScope SCcf

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Set preferred view style.
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
defaults write com.apple.finder FXPreferredViewStyle Nlsv

# Set default path for new windows.
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget PfHm

# Show the ~/Library folder
chflags nohidden ~/Library

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Set dock pop-in delay to 0
defaults write com.apple.dock autohide-time-modifier -int 0

# Set dock position on the down of the screen
defaults write com.apple.dock orientation -string bottom

# Set dock position on the down of the screen
defaults write com.apple.dock mineffect -string scale

# Enable autohide of Dock
defaults write com.apple.dock autohide -float 1

# Remove the Delay for Auto-Hide & Auto-Show of Dock
defaults write com.apple.dock autohide-delay -float "0.5"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Set dock size to 64
defaults write com.apple.dock tilesize -int 64

# Lock dock size
defaults write com.apple.dock size-immutable -bool yes

# Don't show recently used apps in a separate section of the Dock.
defaults write com.apple.dock "show-recents" -bool "false"

# Don’t show Dashboard as a Space
#defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Workaround to fix aerospace behaviour when mission control shows windows too small
defaults write com.apple.dock expose-group-apps -bool true

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → no-op
#defaults write com.apple.dock wvous-bl-corner -int 0
#defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → no-op
#defaults write com.apple.dock wvous-br-corner -int 0
#defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
#hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Kill affected applications                                                  #
###############################################################################
for app in "Dock" "Finder"; do killall "${app}" &> /dev/null; done

success 'Setting up osx'

