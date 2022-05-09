#!/bin/bash
# Script to download my initial stuff
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ixicale/ixicale/seed/ubuntu.setup.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/ixicale/ixicale/seed/ubuntu.setup.sh)"
# or via fetch:
#   sh -c "$(fetch -o - https://raw.githubusercontent.com/ixicale/ixicale/seed/ubuntu.setup.sh)"
#
# As an alternative, you can first download the install script and run it afterwards:
#   wget https://raw.githubusercontent.com/ixicale/ixicale/seed/ubuntu.setup.sh
#   sh ubuntu.setup.sh
# 

setup_color(){
    # Regular Colors

    PR_RESET=$(printf '\033[0m'    )  # Text Reset
    PR_BLACK=$(printf '\033[0;30m' )  # Black
    PR_RED=$(printf '\033[0;31m'   )  # Red
    PR_GREEN=$(printf '\033[0;32m' )  # Green
    PR_YELLOW=$(printf '\033[0;33m')  # Yellow
    PR_BLUE=$(printf '\033[0;34m'  )  # Blue
    PR_PURPLE=$(printf '\033[0;35m')  # Purple
    PR_CYAN=$(printf '\033[0;36m'  )  # Cyan
    PR_WHITE=$(printf '\033[0;37m' )  # White
    PR_RAINBOW="
        $PR_YELLOW
        $PR_CYAN
        $PR_GREEN
        $PR_RED
        $PR_PURPLE
    "
}
print_success(){
    printf "%s          ____          %s_____  %s_____           %s_____________  %s       _  _   %s\n" $PR_RAINBOW $PR_RESET
    printf "%s         /   /         %s/ _  / %s/     \         %s/            / %s_  _   / \/ \  %s\n" $PR_RAINBOW $PR_RESET
    printf "%s   _    /   /         %s/____/ %s/       \       %s/     _______/ %s/ \/ \  \    /  %s\n" $PR_RAINBOW $PR_RESET
    printf "%s  \  \ /   /         %s ___   %s/    _    \     %s/    /         %s \    /   \  /   %s\n" $PR_RAINBOW $PR_RESET
    printf "%s   \  \   /         %s/    / %s/    / \    \   %s/    /___      %s   \  / _  _\/    %s\n" $PR_RAINBOW $PR_RESET
    printf "%s    \    /         %s/    / %s/    /   \    ) %s/        /     %s _   \/ / \/ \     %s\n" $PR_RAINBOW $PR_RESET
    printf "%s    /   \         %s/    / %s/    /    /   / %s/    ____/     %s / \/ \  \    /     %s\n" $PR_RAINBOW $PR_RESET
    printf "%s   /     \       %s/    / %s/    /    /   / %s/    /         %s  \    /   \  /      %s\n" $PR_RAINBOW $PR_RESET
    printf "%s  /   /\  \     %s/    / %s/    /____/   / %s/    /________ %s    \  /     \/       %s\n" $PR_RAINBOW $PR_RESET
    printf "%s /   /  \  \   %s/    / %s/             / %s/             /%s      \/               %s\n" $PR_RAINBOW $PR_RESET
    printf "%s/___/    \__\ %s/____/ %s/_____________/ %s/_____________/%s  $PR_GREEN ....is now installed %s\n" $PR_RAINBOW $PR_RESET
    echo ""
    echo ""
    echo "  Now you are part of the Xide's family because you are downloading 'the seed'."
    echo "  Using 'the seed' is your own responsibilily of all stuff downloaded from here. Now, Enjoy! :)"
    echo ""
    echo ""
}
create_main_container(){
    mkdir $HOME/._;
}
up_to_day(){
    sudo apt -y update;
    sudo apt -y upgrade;
}
setup_package_to_install(){
    sudo apt install git xclip zsh fonts-powerline curl;
    sudo snap install --classic code;
}
setup_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";
}

main(){
    up_to_day
    create_main_container
    setup_package_to_install
    setup_color
    print_success
    setup_oh_my_zsh
}


main
