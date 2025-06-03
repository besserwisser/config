
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="hyperzsh"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git globalias colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"


# pnpm
export PNPM_HOME="/Users/oliverweiss/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


[[ $NODE_OPTIONS != *"--dns-result-order=ipv4first"* ]] && export NODE_OPTIONS="${NODE_OPTIONS:+$NODE_OPTIONS }--dns-result-order=ipv4first"

export XDG_CONFIG_HOME="$HOME/.config"
export VCPKG_ROOT="$HOME/vcpkg"


export CDFPATH=~/myshortcuts

#
# cdf.sh
# Version 0.4
# (C) 2024 by Martin Hepp, https://www.heppnetz.de
# Github repository: https://github.com/mfhepp/cdf
# Available under the MIT License


_cdf_check_environment() {
   # Check if CDFPATH is set
   if [ -z "${CDFPATH}" ]; then
      printf "ERROR: Favorites path not set via CDFPATH\n"
      return 1
   # Check if value is an existing directory
   elif [ ! -d "${CDFPATH}" ]; then
      printf "ERROR: Favorites directory $CDFPATH does not exist\n"
      return 1  # Exit the function with a non-zero status
   else
      printf "INFO: CDFPATH is set to $CDFPATH\n"
   fi
   # Check if realpath is available
   if ! command -v realpath >/dev/null 2>&1; then
      printf "ERROR: The required realpath command is not supported on this platform\n"
      return 1
   fi
   if ! command -v ln >/dev/null 2>&1; then
      printf "ERROR: The required ln command is not supported on this platform\n"
      return 1
   fi
   if ! command -v find >/dev/null 2>&1; then
      printf "ERROR: The required find command is not supported on this platform.\n"
      return 1
   fi       
}

# Function to check if name for shortcut is a safe name for the symbolic link
_validate_basename() {
    local input="$1"
    if [ -z "$input" ]; then
       # echo "ERROR: Argument is empty."
       return 1
    fi
    local sanitized
    # Remove leading and trailing whitespace and replace forbidden characters
    sanitized=$(echo "$input" | xargs | sed 's/[^a-zA-Z0-9_-]/_/g')
    if [ "$sanitized" != "$input" ]; then
        # echo "ERROR: Argument contains invalid characters (consider $sanitized instead)"
        return 1
    fi
}


_cdf_list() {
   # List all available shortcuts   
   printf "Usage: cdf NAME\n\n"
   printf "Existing directory shortcuts are:\n"
   # Note: We are looking for symbolic links, hence l
   # Old version: find $CDFPATH -maxdepth 1 -type l  -exec basename {} \; | sort | sed 's/^/ - /'
   # for link in ./*; do echo " - $(basename "$link")  [$(readlink -f "$link")]"; done
   find "$CDFPATH" -maxdepth 1 -type l -print0 | while IFS= read -r -d '' symlink; do
      printf " - $(basename "$symlink")  [$(realpath "$symlink")]\n"
   done   
   printf "\n"
}

addfav() {
   # Define addfav command, adds PWD as a symbolic link
   if ! _cdf_check_environment; then
     return 1
   fi
   if [ $# -eq 0 ] || [ "$1" = "--help" ]; then
      printf "ADDFAV: Adds the current directory as a shortcut to CDFPATH\n"
      printf 'Usage: addfav NAME\n\n'
      printf 'Example:\n'
      printf '  addfav project-a: Add current directory as "project-a"\n'
      printf '  addfav --help:    Show help\n'
      printf '  addfav --list:    List all available shortcuts\n'
   elif [ "$1" = "--list" ]; then
      # List all available shortcuts
      _cdf_list
   else
      # Check that the current directory is neither the place for the symlinks nor a subdirectory therof
      CURRENT_DIR=$(pwd)
      # Bash-only version: if [[ "$CURRENT_DIR" = "$CDFPATH" || "$CURRENT_DIR" == "$CDFPATH"/* ]]; then
      if [ "$CURRENT_DIR" = "$CDFPATH" ] || [ "${CURRENT_DIR##$CDFPATH/}" != "$CURRENT_DIR" ]; then
        printf "ERROR: You cannot create shortcuts to the shortcuts folder or its subdirectories\n"
        return 1
      # Check if we are INSIDE a symbolic link
      elif [ "$CURRENT_DIR" != $(realpath $CURRENT_DIR) ]; then
        printf "ERROR: You cannot create shortcuts to symbolic links\n"
        printf "Hint: $CURRENT_DIR expands to $(realpath "$CURRENT_DIR")\n"
        return 1
      fi
      # Check if argument is a valid basename
      if ! _validate_basename "$1"; then
         printf "ERROR: Invalid name for shortcut\n"
         return 1
      fi
      filepath="$CDFPATH/$1"
      if [ -e "$filepath" ]; then
         printf "ERROR: Shortcut $1 is already in use (or another file or directory $filepath exists)\n"
         return 1
      else         
         ln -s "$PWD" "$filepath"
         if [ $? -eq 0 ]; then
            printf "OK: Shortcut $1 for $PWD added\n"
         else
            printf "ERROR: Failed to create shortcut $1 for $PWD\n"
            return 1
         fi
      fi 
   fi
}

cdf() {
   # Define cdf command ("change to favorite")
   if ! _cdf_check_environment; then
      return 1
   fi
   if [ $# -eq 0 ] || [ "$1" = "--help" ]; then
      printf "CDF: Change to a directory via a shortcut from CDFPATH\n"
      printf 'Usage: cdf NAME\n\n'
      printf 'Example:\n'
      printf '  cdf project-a: Change to the directory saved as "project-a"\n'
      printf '  cdf --help:    Show help\n'
      printf '  cdf --list:    List all available shortcuts\n\n'
      printf 'Hint: Use the TAB key for autocomplete with available shortcuts\n'
   elif [ "$1" = "--list" ]; then
      # List all available shortcuts
      _cdf_list
   else
      # Check if argument is a valid basename
      if ! _validate_basename "$1"; then
         printf "ERROR: Invalid name for shortcut\n"
         return 1
      fi
      filepath="$CDFPATH"/"$1"
      if [ -L "$filepath" ]; then
         printf "Following the symbolic link: $filepath\n"
         real_path=$(realpath "$filepath")
         cd "$real_path"
         if [ $? -eq 0 ]; then
            printf "You are now here: $(pwd)\n"
         else
            printf "ERROR: Failed to change directory to $real_path\n"
            return 1
         fi
      else
         printf "ERROR: Shortcut $1 does not exist as a symbolic link in $CDFPATH\n"
         return 1
      fi
   fi
}

# Define autocomplete helper (currently limited to Bash)
# Credits to ChatGPT 4
_cdf_autocomplete() {
    local cur files
    if [ -n "$BASH_VERSION" ]; then
        # Bash environment
        cur=${COMP_WORDS[COMP_CWORD]}
    elif [ -n "$ZSH_VERSION" ]; then
        # Zsh environment
        cur=${words[CURRENT]}
    fi
    # Use a wildcard pattern to get symbolic links
    local IFS=$'\n'
    files=()
    for file in "$CDFPATH"/*; do
        [ -L "$file" ] && files+=("$(basename "$file")")
    done
    if [ -n "$BASH_VERSION" ]; then
        # Bash completion
        COMPREPLY=($(compgen -W "${files[*]}" -- "$cur"))
    elif [ -n "$ZSH_VERSION" ]; then
        # Zsh completion
        compadd -- "${files[@]}"
    fi
}

# Set up completion for the shell
# For the moment, we keep this in cdf.sh
# This adds a bit of overhead but simplifies the installation

if [ -n "$BASH_VERSION" ]; then
    complete -F _cdf_autocomplete cdf
elif [ -n "$ZSH_VERSION" ]; then
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
    compdef _cdf_autocomplete cdf
fi

alias vim="nvim"
alias vi="nvim"
alias vimdiff='nvim -d'
alias nx="pnpx nx"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/oliverweiss/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
when() {
  pastDayOffset="0"
  breakTimeInMinutes="30" # Total planned break duration for the day

  # --- New: Define your total required work duration ---
  # For example, 7 hours and 30 minutes
  totalWorkHours=7
  totalWorkMinutes=30
  # --- End New ---

  # Get current time as end timestamp for "so far" calculations
  endTimestamp=$(date +"%Y-%m-%d %H:%M:%S")
  # Determine the date for which to find the start event
  offsettedDate=$(date -v-"$pastDayOffset"d +"%Y-%m-%d")

  # Get the first time the display turned on for the target date
  startLine=$(pmset -g log | grep "$offsettedDate.*Display is turned on" | head -n 1)
  startTimestampString=$(echo "$startLine" | cut -c 1-19) # Extract YYYY-MM-DD HH:MM:SS

  if [ -z "$startTimestampString" ]; then
    echo "No 'Display is turned on' event found for $offsettedDate."
    return 1
  fi

  print "\nWorkday Details:"
  print "-------------------------------------------"
  print "Start time (Display on): $startTimestampString"
  print "Current time:            $endTimestamp"
  print "Planned break:           $breakTimeInMinutes minutes"
  printf "Required work duration:  %d hours %d minutes\n" "$totalWorkHours" "$totalWorkMinutes"
  printf "-------------------------------------------\n"

  # Convert timestamps to seconds since epoch
  startTimestampInSeconds=$(date -j -f "%Y-%m-%d %H:%M:%S" "$startTimestampString" +%s)
  currentTimestampInSeconds=$(date -j -f "%Y-%m-%d %H:%M:%S" "$endTimestamp" +%s)

  # Calculate total elapsed time since display turned on
  totalTimeElapsedInSeconds=$((currentTimestampInSeconds - startTimestampInSeconds))

  # Calculate actual work done so far (assuming planned break is taken from elapsed time)
  actualWorkDoneSoFarInSeconds=$((totalTimeElapsedInSeconds - (breakTimeInMinutes * 60)))

  # Ensure actual work done is not negative (e.g., if elapsed time is less than break time)
  if [ "$actualWorkDoneSoFarInSeconds" -lt 0 ]; then
    actualWorkDoneSoFarInSeconds=0
  fi

  # Convert durations to human-readable format (HH:MM:SS)
  humanReadableTimeElapsed=$(date -u -r "$totalTimeElapsedInSeconds" +"%T" 2>/dev/null || echo "00:00:00")
  humanReadableActualWorkDone=$(date -u -r "$actualWorkDoneSoFarInSeconds" +"%T" 2>/dev/null || echo "00:00:00")

  printf "Time since display on:      %s\n" "$humanReadableTimeElapsed"
  printf "Assumed actual work so far: %s (after subtracting %s min break)\n\n" "$humanReadableActualWorkDone" "$breakTimeInMinutes"

  # --- New Calculations for remaining work and stop time ---

  # Convert total required work duration to seconds
  totalRequiredWorkInSeconds=$(( (totalWorkHours * 60 * 60) + (totalWorkMinutes * 60) ))

  # Calculate the epoch timestamp for when work should ideally finish
  # This is: Start Time + Required Work Duration + Planned Break Duration
  expectedStopTimeEpoch=$((startTimestampInSeconds + totalRequiredWorkInSeconds + (breakTimeInMinutes * 60)))
  humanReadableExpectedStopTime=$(date -r "$expectedStopTimeEpoch" +"%H:%M:%S")
  humanReadableExpectedStopDate=$(date -r "$expectedStopTimeEpoch" +"%Y-%m-%d")


  # Calculate remaining time from "now" (currentTimestampInSeconds) until the expectedStopTimeEpoch
  timeUntilExpectedStopInSeconds=$((expectedStopTimeEpoch - currentTimestampInSeconds))

  print "Work Progress:"
  print "-------------------------------------------"
  if [ "$timeUntilExpectedStopInSeconds" -gt 0 ]; then
    # Still time to work
    # How much *more work* is needed from the total requirement?
    workStillToDoInSeconds=$((totalRequiredWorkInSeconds - actualWorkDoneSoFarInSeconds))
    if [ "$workStillToDoInSeconds" -lt 0 ]; then # Should not happen if timeUntilExpectedStopInSeconds > 0 and logic is right
        workStillToDoInSeconds=0                 # But as a safeguard
    fi
    humanReadableWorkStillToDo=$(date -u -r "$workStillToDoInSeconds" +"%T" 2>/dev/null || echo "00:00:00")
    
    printf "Work remaining:           %s\n" "$humanReadableWorkStillToDo"
    printf "You can stop working at:  %s \n" "$humanReadableExpectedStopTime"
  else
    # Work quota should be met or exceeded
    printf "Work quota should be met!\n"
    printf "Expected stop time was:   %s \n" "$humanReadableExpectedStopTime" 
    
    overtimeInSeconds=$((timeUntilExpectedStopInSeconds * -1)) # Make it positive
    if [ "$overtimeInSeconds" -gt 1 ]; then # Check if actually overtime (more than 1 second)
        humanReadableOvertime=$(date -u -r "$overtimeInSeconds" +"%T" 2>/dev/null || echo "00:00:00")
        printf "You have worked %s overtime.\n" "$humanReadableOvertime"
    fi
  fi
  printf "-------------------------------------------\n"
}
export NX_TUI=false
