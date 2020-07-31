Вырезаем с помощью прокси squid все видео и картинки для всех сайтов, кроме в списке whitelist.txt.

Для youtube включаем принудительно строгий режим 


Предупреждение
------------
Вся информация в статье представлена исключительно в образовательных целях и если вы что-то делаете, то делаете это исключительно на свой страх и риск.

Автор публикации не несёт ответственности за любые последствия ваших необдуманных действий.

Установка для Windows 10
------------   

1. Скачиваем и устанавливаем squid в C:\squid. Берем [здесь](http://squid.diladele.com/)

2. Для фильтрации HTTPS ресурсов необходимо делать подмену сертификата. Для этого скачиваем и устанавливаем OpenSSL  для генерирования собственного Certificate Authority - берется [здесь](https://slproweb.com/products/Win32OpenSSL.html). Будет достаточно light-пакета на 3Мб.

идем в каталог bin, открываем от Администратора cmd.exe, вбиваем туда:
```
openssl req -new -newkey rsa:1024 -days 1825 -nodes -x509 -keyout squidCA.pem -out squidCA.pem

openssl x509 -in squidCA.pem -outform DER -out browserCA.der 
```
Первая команда создает сертификат SquidCA.pem для генерации вторичных сертификатов. При создании вводим любые данные. Копируем его в C:\squid\etc\bump

Вторая команда конвертирует этот сертификат в формат для импорта в браузер (если Firefox) или систему (если все остальное). 

Для импорта сертификата в систему открываем certmgr.msc. Импортируем этот сертификат в Доверенные корневые центры сертификации.

3. Идем в C:\squid\lib\squid, открываем командную строку,
```
ssl_crtd.exe -c -s C:\squid\etc\bump\ssldb (ВАЖНО: каталога ssldb существовать не должно, иначе вылезет ошибка!)
```
4. Переписываем из репозитория файлы squid.conf, whitelist.txt, blacklist.txt, graylist.txt, domain_mismatch.txt в папку C:\Squid\etc\squid
5. Для установки правил брандмауэра и пароля Администратора запускаем с правами от администратора policy_set.cmd

рекомендую для начальной настройки ввести пустой пароль Администратора и ,если все заработает, то ввести случайный пароль, который забываем

ОСТОРОЖНО: для сброса пароля нужен будет live cd

6. Выбираем в браузере прокси-сервером HTTP прокси 127.0.0.1 порт 3128. Используем этот прокси-сервер для всех протоколов

Если где-то накосячено - то читаем C:\Squid\var\log\squid\cache.log и исправляем накосяченное.

Установка для Ubuntu
------------ 
...

### :link: Ссылки
* [Установка прокси-сервера Squid под Windows (HTTPS + AUFS + ROCK)](https://rustedowl.livejournal.com/44380.html) 
* [Прозрачный прокси для HTTPS в Squid](https://losst.ru/prozrachnyj-proksi-dlya-https-v-squid) 
