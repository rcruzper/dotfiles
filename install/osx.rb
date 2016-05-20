$LOAD_PATH.unshift File.dirname(__FILE__) + '/tools'
require 'logging'
require 'command'

module Osx
  module_function

  def setup
    Log.info 'Setting up osx (It will restart Dock and Finder)'

    ###############################################################################
    # General UI/UX                                                               #
    ###############################################################################

    # Always show scrollbars
    Command.execute 'defaults write NSGlobalDomain AppleShowScrollBars -string "Always"'

    # Save to disk (not to iCloud) by default
    Command.execute 'defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false'

    # Disable the “Are you sure you want to open this application?” dialog
    Command.execute 'defaults write com.apple.LaunchServices LSQuarantine -bool false'

    ###############################################################################
    # Finder                                                                      #
    ###############################################################################

    # Finder: show all filename extensions
    Command.execute 'defaults write NSGlobalDomain AppleShowAllExtensions -bool true'

    # Finder: show status bar
    Command.execute 'defaults write com.apple.finder ShowStatusBar -bool true'

    # Finder: show path bar
    Command.execute 'defaults write com.apple.finder ShowPathbar -bool true'

    # Show icons for hard drives, servers, and removable media on the desktop
    Command.execute 'defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true'
    Command.execute 'defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false'
    Command.execute 'defaults write com.apple.finder ShowMountedServersOnDesktop -bool true'
    Command.execute 'defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true'

    # When performing a search, search the current folder by default
    Command.execute 'defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"'

    # Disable the warning when changing a file extension
    Command.execute 'defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false'

    # Avoid creating .DS_Store files on network volumes
    Command.execute 'defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true'

    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    Command.execute 'defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"'

    # Show the ~/Library folder
    Command.execute 'chflags nohidden ~/Library'

    ###############################################################################
    # Dock, Dashboard, and hot corners                                            #
    ###############################################################################

    # Minimize windows into their application’s icon
    Command.execute 'defaults write com.apple.dock minimize-to-application -bool true'

    # Disable Dashboard
    Command.execute 'defaults write com.apple.dashboard mcx-disabled -bool true'

    # Don’t show Dashboard as a Space
    Command.execute 'defaults write com.apple.dock dashboard-in-overlay -bool true'

    # Don’t automatically rearrange Spaces based on most recent use
    Command.execute 'defaults write com.apple.dock mru-spaces -bool false'

    # Reset Launchpad, but keep the desktop wallpaper intact
    Command.execute 'find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete'

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
    Command.execute 'defaults write com.apple.dock wvous-tl-corner -int 2'
    Command.execute 'defaults write com.apple.dock wvous-tl-modifier -int 0'
    # Top right screen corner → Desktop
    Command.execute 'defaults write com.apple.dock wvous-tr-corner -int 4'
    Command.execute 'defaults write com.apple.dock wvous-tr-modifier -int 0'
    # Bottom left screen corner → Start screen saver
    Command.execute 'defaults write com.apple.dock wvous-bl-corner -int 5'
    Command.execute 'defaults write com.apple.dock wvous-bl-modifier -int 0'

    ###############################################################################
    # Time Machine                                                                #
    ###############################################################################

    # Prevent Time Machine from prompting to use new hard drives as backup volume
    Command.execute 'defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true'

    # Disable local Time Machine backups
    Command.execute 'hash tmutil &> /dev/null && sudo tmutil disablelocal'

    ###############################################################################
    # Kill affected applications                                                  #
    ###############################################################################
    Command.execute 'for app in "Dock" "Finder"; do killall "${app}" &> /dev/null; done'

    Log.success 'Setting up osx'
  end
end