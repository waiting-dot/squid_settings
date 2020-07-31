@echo off
@chcp 65001

echo Включение среды восстановления системы
@reagentc /enable

echo Сброс пароля администратора
@net user Администратор ""

echo Сбросим прокси
@netsh winhttp reset proxy

echo Сброс брандмауэра
@netsh advfirewall reset


pause

