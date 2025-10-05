# linux_monitoring_test

Репозиторий с тестовым заданием для вакансии DevOps инженера

## Требования к скрипту мониторинга

Написать скрипт на bash для мониторинга процесса `test` в среде Linux. Скрипт должен отвечать следующим требованиям:

1. Запускаться при запуске системы (предпочтительно написать юнит systemd в дополнение к скрипту)
2. Отрабатывать каждую минуту
3. Если процесс запущен, то стучаться (по https) на `https://test.com/monitoring/test/api`
4. Если процесс был перезапущен, писать в лог `/var/log/monitoring.log` (если процесс не запущен, то ничего не делать)
5. Если сервер мониторинга не доступен, так же писать в лог

## Установка и запуск

1. Скопировать скрипт в `/usr/local/bin` и выдать права на выполнение:

   ```bash
   sudo cp monitor_test.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/monitor_test.sh
   ```

2. Создать файл логов:

   ```bash
   sudo touch /var/log/monitoring.log
   sudo chmod 644 /var/log/monitoring.log
   ```

3. Скопировать юнит и таймер systemd:

   ```bash
   sudo cp monitor-test.service /etc/systemd/system/
   sudo cp monitor-test.timer /etc/systemd/system/
   ```

4. Перезагрузить systemd и включить таймер:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now monitor-test.timer
   ```