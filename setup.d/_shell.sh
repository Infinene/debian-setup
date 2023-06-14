${SUDO} apt update
${SUDO} apt -y install lsb-release

### backports ###
grep -e "^deb.*backports" /etc/apt/sources.list >/dev/null || \
    echo -e "\ndeb http://deb.debian.org/debian $(lsb_release -sc)-backports main contrib non-free" \
    | ${SUDO} tee -a /etc/apt/sources.list
echo -e "Package: *\nPin: release a=$(lsb_release -sc)-backports\nPin-Priority: 500\n" \
    | ${SUDO} tee /etc/apt/preferences.d/backports

${SUDO} apt update
${SUDO} apt -y full-upgrade
### required by php-mysql-nginx ###
${SUDO} apt -y install apt-transport-https ca-certificates curl wget software-properties-common dirmngr gnupg2 debian-archive-keyring sudo rsync
### extras ###
${SUDO} apt -y install zstd unzip ncdu htop mmv neofetch git autojump tmux ncal

### bash setup ###
echo -e "EDITOR=micro\nVISUAL=micro\n" | ${SUDO} tee -a /etc/environment
[[ $is_wsl ]] && ${SUDO} cp $setup_dir/etc/wsl.conf /etc/

cat $setup_dir/home/.config/bash/prompt | sed 's/34/35/g' | ${SUDO} tee -a /root/.bashrc
if [ ! $UID = 0 ]; then
    # cp -rTv $setup_dir/home $HOME
    cp -rv $setup_dir/home/. $HOME
    echo -e '\n. ~/.config/bash/prompt' | tee -a $HOME/.bashrc
    echo '. ~/.config/bash/utils_env' | tee -a $HOME/.bashrc
    echo '. /usr/share/autojump/autojump.bash' | tee -a $HOME/.bashrc
    echo 'if [ -f /usr/bin/neofetch ]; then neofetch; fi' | tee -a $HOME/.bashrc
    cd $HOME
    ln -s .config/bash/aliases .bash_aliases
    echo -e "\nDefaults:${USER} timestamp_timeout=90" | sudo tee -a /etc/sudoers
    [[ $is_wsl ]] && echo -e "${USER} ALL=(ALL) NOPASSWD:/usr/sbin/service" | sudo tee -a /etc/sudoers
fi

echo -e "\nInstalling utils..." && $HOME/.local/bin/update_utils
${SUDO} cp -rbv $setup_dir/etc/lf /etc/