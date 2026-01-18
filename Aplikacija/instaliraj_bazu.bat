@echo off
echo Pokrecem instalaciju baze podataka: korisnici_projekt...

"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -c "CREATE DATABASE korisnici_projekt;"

"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d korisnici_projekt -f setup.sql

echo.
echo Baza 'korisnici_projekt' je kreirana i napunjena!
pause