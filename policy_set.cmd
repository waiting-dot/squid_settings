@echo off
@chcp 65001

echo Отключение среды восстановления системы
@reagentc /disable

echo Понижение прав текущего пользователя
@for /f "delims=" %%a in ('whoami') do set "var=%%a"
@net localgroup Пользователи "%var%" /add
@net localgroup Администраторы "%var%" /delete

echo Установка пароля для администратора
@net user Администратор /active:yes
@set /p adminpass="Ведите новый пароль для администратора: "
@net user Администратор "%adminpass%"

echo Сделаем папку C:\Squid\etc\squid только для чтения
icacls.exe "C:\Squid\etc\squid\*" /reset
icacls.exe "C:\Squid\etc\squid\*" /GRANT:R "%var%":R
icacls.exe "C:\Squid\etc\squid\*" /inheritance:r

echo Перезагрузим сервер squid
@net stop /y squidsrv && net start squidsrv

echo Установим прокси для браузера
@netsh winhttp set proxy "127.0.0.1:3128"
@set HTTP_PROXY=127.0.0.1:3128
@set FTP_PROXY=%HTTP_PROXY%
@set HTTPS_PROXY=%HTTP_PROXY%

echo Включение брандмауэра
@netsh advfirewall set allprofiles state on

echo Сброс брандмауэра
@netsh advfirewall reset

echo Закроем исходящие подключения
@netsh advfirewall set allprofile firewallpolicy allowinbound,blockoutbound

echo Откроем исходящие подключения по портам 80,443 сквиду
@netsh advfirewall firewall add rule name="Allow-squid-80,443" dir=OUT action=allow protocol=TCP remoteport=80,443 program="%SystemDrive%\Squid\bin\squid.exe" profile=any

echo Откроем исходящие подключения по порту 53 сквиду для dns 
@netsh advfirewall firewall add rule name="Allow-dns-53" dir=out action=allow protocol=UDP remoteport=53 program="%SystemDrive%\Squid\bin\squid.exe" profile=any

echo Откроем исходящие подключения для службы dhcp
@netsh advfirewall firewall add rule name="Allow-dhcp-67" dir=out action=allow protocol=UDP localport=68 remoteport=67 program="%%systemroot%%\system32\svchost.exe" service="dhcp" profile=any

pause

