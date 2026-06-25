#!/bin/zsh
set -eEuxo pipefail

# /etc/apt/sources.list.d/debian.sources
# Types: deb deb-src
# URIs: http://deb.debian.org/debian
# Suites: trixie trixie-updates trixie-security
# Components: main non-free-firmware
# Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

apt update
# apt upgrade
apt install -y ca-certificates && update-ca-certificates
apt install -y zsh vim curl git tree bzip2
# apt install smartmontools nvme-cli
# apt autoremove --purge
# apt clean

# chsh -s /bin/zsh root
# infocmp -x xterm-ghostty | ssh root@... -- tic -x -

curl -fsSL https://astral.sh/uv/install.sh | UV_INSTALL_DIR=/usr/local/bin sh
uv generate-shell-completion zsh > /usr/share/zsh/vendor-completions/_uv

JAQ_VERSION=$(curl -fsSL https://api.github.com/repos/01mf02/jaq/releases/latest | jaq -r .tag_name) || JAQ_VERSION="v3.1.0"
JAQ_VERSION=${JAQ_VERSION#v}
curl -fsSLo /usr/local/bin/jaq "https://github.com/01mf02/jaq/releases/download/v${JAQ_VERSION}/jaq-x86_64-unknown-linux-gnu"
chmod +x /usr/local/bin/jaq

BAT_VERSION=$(curl -fsSL https://api.github.com/repos/sharkdp/bat/releases/latest | jaq -r .tag_name)
BAT_VERSION=${BAT_VERSION#v}
curl -fsSLo ~/bat.deb https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb
dpkg -i ~/bat.deb
rm ~/bat.deb

FD_VERSION=$(curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest | jaq -r .tag_name)
FD_VERSION=${FD_VERSION#v}
curl -fsSLo ~/fd.deb https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb
dpkg -i ~/fd.deb
rm ~/fd.deb

RG_VERSION=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jaq -r .tag_name)
RG_VERSION=${RG_VERSION#v}
curl -fsSLo ~/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep_${RG_VERSION}-1_amd64.deb
dpkg -i ~/ripgrep.deb
rm ~/ripgrep.deb

FZF_VERSION=$(curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest | jaq -r .tag_name)
FZF_VERSION=${FZF_VERSION#v}
curl -fsSLo ~/fzf.tgz https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz
tar -xzf ~/fzf.tgz -C /usr/local/bin "fzf"
chown root:root /usr/local/bin/fzf
rm ~/fzf.tgz
fzf --zsh > /usr/share/zsh/vendor-completions/_fzf

RESTIC_VERSION=$(curl -fsSL https://api.github.com/repos/restic/restic/releases/latest | jaq -r .tag_name)
RESTIC_VERSION=${RESTIC_VERSION#v}
curl -fsSLo ~/restic.bz2 https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2
bunzip2 ~/restic.bz2
install -D -m 0755 ~/restic /usr/local/bin
rm ~/restic
restic generate --zsh-completion /usr/share/zsh/vendor-completions/_restic

NGINX_VERSION=$(curl -fsSL https://api.github.com/repos/nginx/nginx-prometheus-exporter/releases/latest | jaq -r .tag_name)
NGINX_VERSION=${NGINX_VERSION#v}
curl -fsSLo ~/nginx_exporter.tgz "https://github.com/nginx/nginx-prometheus-exporter/releases/download/v${NGINX_VERSION}/nginx-prometheus-exporter_${NGINX_VERSION}_linux_amd64.tar.gz"
tar -xzf ~/nginx_exporter.tgz -C /usr/local/bin nginx-prometheus-exporter
chown root:root /usr/local/bin/nginx-prometheus-exporter
mv /usr/local/bin/nginx-prometheus-exporter /usr/local/bin/nginx_exporter
rm ~/nginx_exporter.tgz

NODE_VERSION=$(curl -fsSL https://api.github.com/repos/prometheus/node_exporter/releases/latest | jaq -r .tag_name)
NODE_VERSION=${NODE_VERSION#v}
curl -fsSLo ~/node_exporter.tgz "https://github.com/prometheus/node_exporter/releases/download/v${NODE_VERSION}/node_exporter-${NODE_VERSION}.linux-amd64.tar.gz"
tar -xzf ~/node_exporter.tgz -C /usr/local/bin --strip-components=1 --wildcards "*/node_exporter"
chown root:root /usr/local/bin/node_exporter
rm ~/node_exporter.tgz

ZIG_VERSION=$(curl -fsSL "https://codeberg.org/api/v1/repos/ziglang/zig/tags" | jaq -r '.[0].name')
curl -fsSLo ~/zig.txz "https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz"
tar -xf ~/zig.txz -C /usr/local/bin --strip-components=1 --wildcards "*/zig" "*/lib/*"
chown -R root:root /usr/local/bin/zig /usr/local/bin/lib
mv /usr/local/bin/lib /usr/local/lib/zig
rm ~/zig.txz
curl -fsSLo /usr/share/zsh/vendor-completions/_zig https://codeberg.org/ziglang/shell-completions/raw/branch/master/_zig

EZA_VERSION=$(curl -fsSL https://api.github.com/repos/eza-community/eza/releases/latest | jaq -r .tag_name)
curl -fsSLo ~/eza.tgz "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz"
tar -xzf ~/eza.tgz -C /usr/local/bin eza
chown root:root /usr/local/bin/eza
rm ~/eza.tgz

STARSHIP_VERSION=$(curl -fsSL https://api.github.com/repos/starship/starship/releases/latest | jaq -r .tag_name)
curl -fsSLo ~/starship.tgz "https://github.com/starship/starship/releases/download/${STARSHIP_VERSION}/starship-x86_64-unknown-linux-gnu.tar.gz"
tar -xzf ~/starship.tgz -C /usr/local/bin starship
chown root:root /usr/local/bin/starship
rm ~/starship.tgz

