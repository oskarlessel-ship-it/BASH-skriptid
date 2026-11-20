#!/bin/bash
# 'set -e' aktiveerib Bash'i vearežiimi
set -e

# Määrame paigalduse mitteküsimuste režiimi.
export DEBIAN_FRONTEND=noninteractive

# Uuendame paketiandmebaasi ja paigaldame vajalikud tööriistad
apt update
apt install -y gnupg ca-certificates debconf-utils wget

# 1. Valmistame vastused mysql-apt-config paketi küsimustele automaatselt
echo "mysql-apt-config mysql-apt-config/select-server select mysql-8.0" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-tools select Disabled" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-product select Ok" | debconf-set-selections

# 2. Vastame MySQL serveri paigalduse ja root-parooli küsimustele
echo "mysql-community-server mysql-community-server/root-pass password qwerty" | debconf-set-selections
echo "mysql-community-server mysql-community-server/re-root-pass password qwerty" | debconf-set-selections

# 3. Valime kasutatava autentimisplugina
echo "mysql-community-server mysql-server/default-auth-override select Use Strong Password Encryption (RECOMMENDED)" | debconf-set-selections

# 4. Laeme alla ja paigaldame MySQL ametliku APT konfiguratsioonipaketi (versioon 0.8.40-1)
wget -O /tmp/mysql-apt-config_0.8.40-1_all.deb https://dev.mysql.com/get/mysql-apt-config_0.8.40-1_all.deb
dpkg -i /tmp/mysql-apt-config_0.8.40-1_all.deb

# 5. Uuendame paketiinfot ja paigaldame MySQL Serveri
apt update
apt install -y mysql-server

# 6. Lubame MySQL teenusel automaatselt käivituda ja käivitame selle kohe
systemctl enable --now mysql
echo "Valmis: Oracle MySQL 8.0 on installidud. Root-parool: qwerty"
mysql --version || true

# 7. Lisame koodi .my.cnf faili koostamiseks
cat >"$HOME/.my.cnf" <<'EOF'
[client]
host=localhost
user=root
password=qwerty
EOF
chmod 600 "$HOME/.my.cnf"
