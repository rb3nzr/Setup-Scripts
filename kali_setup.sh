#!/bin/bash 

function get_release() {
    local repo="$1"   
    local filename="$2" 

    local tag=$(curl -s "https://api.github.com/repos/${repo}/releases/latest" | grep -oP '"tag_name":\s*"\K[^"]+')

    if [[ -n "$tag" ]]; then
        local url="https://github.com/${repo}/releases/download/${tag}/${filename}"
        wget -O "${filename}" "$url"
    else
        echo "Error: Failed to fetch the latest release tag for ${repo}" >&2
        return 1
    fi
}

echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER 

# -------------------- [ Packages & Tools ] -------------------- #

sudo apt update -y # && sudo apt upgrade -y
sudo apt install -y terminator htop pipenv rlwrap pipx jq docker.io autoconf
sudo apt install -y cargo golang-go mono-mcs wine mono-complete winetricks
sudo apt install -y bloodhound krb5-user libpam-krb5 libpam-ccreds ntpdate faketime
sudo apt install -y crowbar certipy-ad altdns oscanner tnscmd10g trufflehog sshuttle gobuster feroxbuster

winetricks dotnet48

mkdir ~/tools

curl https://nim-lang.org/choosenim/init.sh -sSf | sh
echo "export PATH=/home/kali/.nimble/bin:$PATH" >> ~/.zshrc
. ~/.zshrc
nimble install winim checksums nimcrypto ptr_math puppy winregistry
nimble install https://github.com/nbaertsch/nimvoke

curl https://sliver.sh/install | sudo bash

pipx ensurepath
. ~/.zshrc
pipx install git+https://github.com/Tib3rius/AutoRecon.git 
pipx install git+https://github.com/login-securite/DonPAPI.git
pipx install impacket

cd ~/tools
get_release "icsharpcode/AvaloniaILSpy" "Linux.x64.Release.zip"
unzip Linux.x64.Release.zip -d ILSpy; rm Linux.x64.Release.zip
unzip ILSpy/ILSpy-linux-x64-Release.zip
cat > ~/Desktop/ILSpy.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ILSpy
Exec=/home/kali/tools/ILSpy/artifacts/linux-x64/ILSpy
Icon=/home/kali/tools/ILSpy/artifacts/linux-x64/Images/ILSpy.png
Terminal=false 
Categories=Reverse Engineering
EOF

get_release "DominicBreuker/pspy" "pspy64"
get_release "DominicBreuker/pspy" "pspy32"
mkdir pspy; mv pspy32 pspy; mv pspy64 pspy

get_release "ropnop/kerbrute" "kerbrute_linux_amd64"
chmod +x kerbrute_linux_amd64; mv kerbrute_linux_amd64 ~/.local/bin/kerbrute

git clone https://github.com/nicocha30/ligolo-ng.git
cd ligolo-ng
make
cd ~/tools

get_release "antonioCoco/RemotePotato0" "RemotePotato0.zip"
get_release "BeichenDream/GodPotato" "GodPotato-NET4.exe"
git clone https://github.com/zcgonvh/EfsPotato.git 
mkdir potatos
mcs EfsPotato/EfsPotato.cs
mv EfsPotato/EfsPotato.exe potatos; mv EfsPotato potatos
mv RemotePotato0.zip potatos; unzip potatos/RemotePotato0.zip -d potatos; rm potatos/RemotePotato0.zip
mv GodPotato-NET4.exe potatos

git clone https://github.com/TheWover/donut.git
cd ~/tools/donut
make
cd ~/tools

get_release "jpillora/chisel" "chisel_1.10.1_windows_amd64.gz"
get_release "jpillora/chisel" "chisel_1.10.1_linux_amd64.gz"
mkdir chisel; mv chisel_1.10.1_windows_amd64.gz chisel; mv chisel_1.10.1_linux_amd64.gz chisel
gzip -d chisel/*.gz

get_release "pwntester/ysoserial.net" "ysoserial-1dba9c4416ba6e79b6b262b758fa75e2ee9008e9.zip"
mkdir ysoserial; unzip ysoserial-1dba9c4416ba6e79b6b262b758fa75e2ee9008e9.zip -d ysoserial; rm ysoserial-1dba9c4416ba6e79b6b262b758fa75e2ee9008e9.zip
cat > ~/.local/bin/ysoserial <<'EOF'
#!/bin/bash
mono ~/tools/ysoserial/Release/ysoserial.exe "$@"
EOF
chmod +x ~/.local/bin/ysoserial

get_release "peass-ng/PEASS-ng" "linpeas.sh"
get_release "peass-ng/PEASS-ng" "winPEASany.exe"
mkdir peas; mv linpeas.sh peas; mv winPEASany.exe peas

git clone https://github.com/jazzpizazz/catch.git 
cd ~/tools/catch
sudo mkdir /opt/catch
cargo build -r
mv target/release/catch ~/.local/bin
cd ~/tools

git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git 
git clone https://github.com/expl0itabl3/Toolies.git 
git clone https://github.com/411Hall/JAWS.git
get_release "antonioCoco/RunasCs" "RunasCs.zip"
mv Toolies ms-tools; mv Ghostpack-CompiledBinaries ms-tools/ghostpack
unzip RunasCs.zip -d ms-tools; rm RunasCs.zip
mv JAWS ms-tools

git clone https://github.com/ShutdownRepo/pywhisker.git
chmod +x pywhisker/setup.py; sudo python3 pywhisker/setup.py install

git clone https://github.com/skelsec/pypykatz.git
chmod +x pypykatz/setup.py; sudo python3 pypykatz/setup.py install

git clone https://github.com/CravateRouge/bloodyAD
chmod +x bloodyAD/bloodyAD.py
cp bloodyAD/bloodyAD.py ~/.local/bloody

git clone https://github.com/grimlockx/ADCSKiller
chmod +x ADCSKiller/adcskiller.py
cp ADCSKiller/adcskiller.py ~/.local/bin/adcskiller

git clone https://github.com/n00py/LAPSDumper.git
chmod +x LAPSDumper/laps.py
cp LAPSDumper/laps.py ~/.local/bin/lapsdumper

git clone https://github.com/PowerShellMafia/PowerSploit.git
mv PowerSploit ms-tools

git clone https://github.com/samratashok/nishang.git 
mv nishang ms-tools 

git clone https://github.com/arthaud/git-dumper
chmod +x git-dumper/git_dumper.py
cp git-dumper/git_dumper.py ~/.local/bin/gitdumper

git clone https://github.com/lanjelot/patator.git
chmod +x patator/src/patator/patator.py
cp patator/src/patator/patator.py ~/.local/bin/patator

git clone https://github.com/ticarpi/jwt_tool.git
chmod +x jwt_tool/jwt_tool.py
cp jwt_tool/jwt_tool.py ~/.local/bin/jwttool

git clone https://github.com/synacktiv/php_filter_chain_generator.git
chmod +x php_filter_chain_generator/php_filter_chain_generator.py
cp php_filter_chain_generator/php_filter_chain_generator.py ~/.local/bin/phpfchain

git clone https://github.com/antonioCoco/SharPyShell.git
git clone https://github.com/dirkjanm/krbrelayx.git
git clone https://github.com/ayoubfathi/leaky-paths.git
git clone https://github.com/ambionics/phpggc.git
git clone https://github.com/leebaird/discover.git
git clone https://github.com/rb3nzr/LnkPersist.git 

sudo gunzip -d /usr/share/wordlists/rockyou.txt.gz 

find ~/tools -type f -name requirements.txt -exec cat {} + > ~/Desktop/requirements.txt

# -------------------- [ Aliases / Configuration ] -------------------- #

gsettings set org.gnome.desktop.session idle-delay 0 
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -s 0 --create --type int
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-off -s 0 --create --type int
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-sleep -s 0 --create --type int
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-ac -s 14 --create --type int
xfconf-query --channel xfce4-keyboard-shortcuts --property "/commands/custom/F3" --create --type string --set "terminator"

cat > ~/.zsh_aliases <<EOF
alias c='clear'
alias x='exit'
alias h='history -10'
alias hc='history -c'
alias tgz='tar -xvzf'
alias update='sudo apt update -y'
alias tool='kali-treecd ~/tools'
alias desk='kali-treecd ~/Desktop'
alias dl='kali-treecd ~/Downloads'
alias tsl='tree -f /usr/share/wordlists/seclists'
alias tnms='tree -f /usr/share/nmap/scripts'

function fix_time() {
    if [[ -z $1 ]]; then
        echo "Usage: fixt <dc-ip>"
        return 1
    fi
    faketime "$(ntpdate -q "$1" | awk '{print $1" "$2}')" zsh
}
alias fixt=fix_time

function tcp_scan() {
  if [[ -z $1 ]]; then
    echo "Usage: tcp <ip_address>"
    return 1
  fi
  sudo nmap -sCV -T4 --min-rate 10000 "$1"
}
alias tcp=tcp_scan

function udp_scan() {
  if [[ -z $1 ]]; then
    echo "Usage: udp <ip_address>"
    return 1
  fi
  sudo nmap -sUCV -T4 --min-rate 10000 "$1"
}
alias udp=udp_scan

function hex_encode() {
  if [[ -z $1 ]]; then
    echo "Usage: he <string>"
    return 1
  fi
  echo -n "$1" | xxd -p | tr -d '\n'
  echo
}
alias he=hex_encode

function hex_decode() {
  if [[ -z $1 ]]; then
    echo "Usage: hd <hex_string>"
    return 1
  fi
  echo "$1" | xxd -r -p
}
alias hd=hex_decode

function base64_encode() {
  if [[ -z $1 ]]; then
    echo "Usage: be <string>"
    return 1
  fi
  echo -n "$1" | base64
}
alias be=base64_encode

function base64_decode() {
  if [[ -z $1 ]]; then
    echo "Usage: bd <base64_string>"
    return 1
  fi
  echo "$1" | base64 --decode
}
alias bd=base64_decode
EOF

cat >> ~/.zshrc <<EOF
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi
EOF

mkdir ~/.config/terminator
cat > ~/.config/terminator/config <<EOF
[global_config]
[keybindings]
[profiles]
  [[default]]
    background_color = "#12012d"
    background_darkness = 0.92
    background_type = transparent
    font = Fira Code Medium 9
    foreground_color = "#81e9bd"
    scrollback_infinite = True
    palette = "#1f2229:#c0bfbc:#5ebdab:#fea44c:#6937d1:#9755b3:#49aee6:#75a50d:#c64600:#f6f5f4:#47d4b9:#ff8a18:#8951ff:#962ac3:#05a1f7:#e0ff4e"
    use_system_font = False
    title_hide_sizetext = True
    title_transmit_fg_color = "#57faa4"
    title_transmit_bg_color = "#241f31"
    title_receive_fg_color = "#57faa4"
    title_receive_bg_color = "#000000"
    title_inactive_fg_color = "#dc8add"
    title_inactive_bg_color = "#241f31"
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
      profile = default
[plugins]
EOF
