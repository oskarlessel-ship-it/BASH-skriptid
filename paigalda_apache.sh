echo "Uuendan pakettide nimekirja..."
apt update

echo "Paigaldan Apache2 veebiserveri..."
apt install -y apache2

echo "Käivitan Apache teenuse..."
systemctl start apache2
systemctl enable apache2

echo "Apache paigaldus on lõppenud!"
