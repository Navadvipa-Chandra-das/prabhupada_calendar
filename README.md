# Prabhupada_calendar
Translates the text file is the result of the GCal (krishnadays.com) program on Russian language (or any other) and prepares the result for typesetting books.

# Запуск

Для сборки и запуска программы "Конвертилка-переводчик Прабхупада" сначала надо установить язык программирования D ( dlang.org ). Потом необходимо установить недостающие пакеты, как пример для Линукса Fedora:

$ sudo dnf install SDL2 libevent-devel openssl-devel libcurl-devel git-all
$ dub fetch prabhupada_calendar
$ dub run prabhupada_calendar

