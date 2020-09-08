#kontrollib kas apache on installitud
APACHE2=$(dpkg-query -W -f="${Status}" apache2 2>/dev/null | grep -c "ok installed")
#kui väärus on 0 siis apache pole installitud
if [ $APACHE2 -eq 0 ]; then
#ütleb et hakkab installima
echo "Paigaldame apache2"
apt install apache2
echo "Apache on paigaldatud"
#peale apache installimist käivitab selle ja näitab statust
service apache2 start
service apache2 status
#kui vväärtus on 1 siis apache on installitud ja annab teate
elif [ $APACHE2 -eq 1 ]; then
echo "Apache on seadme juba olemas"
#teeb apachele restardi ja näitab statust
service apache2 start
service apache2 status
#lõpp
fi
#skripti lõpp
