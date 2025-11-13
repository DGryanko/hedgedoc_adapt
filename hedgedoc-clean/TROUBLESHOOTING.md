# Troubleshooting HedgeDoc

Швидкі рішення типових проблем.

## WSL2 Debian

### Порожня біла сторінка в браузері

**Причина:** userland-proxy вимкнений

**Рішення:**

```bash
wsl -d Debian bash -c 'echo "{\"iptables\": false, \"dns\": [\"8.8.8.8\", \"8.8.4.4\"], \"userland-proxy\": true}" | sudo tee /etc/docker/daemon.json'
wsl -d Debian bash -c "sudo pkill dockerd && sudo dockerd > /dev/null 2>&1 &"
```

### Docker daemon не запускається

**Рішення:**

```bash
wsl -d Debian bash -c "sudo dockerd > /dev/null 2>&1 &"
```

Зачекай 5 секунд і спробуй знову.

### Порт 3000 зайнятий

**Рішення:** Зміни порт в docker-compose.yml

```yaml
ports:
  - "8080:3000"
```

## Raspberry Pi

### Out of Memory

**Рішення:** Збільш swap

```bash
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# Зміни CONF_SWAPSIZE=100 на CONF_SWAPSIZE=2048
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### Дуже повільно

**Рішення:**

1. Використовуй SD карту класу 10+
2. Обмеж пам'ять контейнерів
3. Закрий інші програми

### База даних не підключається

**Рішення:** Зачекай довше (2-5 хвилин на Pi Zero 2W)

```bash
docker compose logs database
```

## Загальні проблеми

### Контейнери не запускаються

```bash
# Подивись логи
docker compose logs

# Перезапусти
docker compose down
docker compose up -d
```

### Втратив дані

**Перевір volumes:**

```bash
docker volume ls | grep hedgedoc
```

Якщо volume існує, дані не втрачені. Просто запусти контейнери.

### Не можу підключитися з іншого пристрою

**Перевір firewall:**

```bash
# Linux/Raspberry Pi
sudo ufw allow 3000

# Або вимкни firewall (тимчасово)
sudo ufw disable
```

## Корисні команди

```bash
# Статус
docker compose ps

# Логи
docker compose logs -f

# Перезапустити
docker compose restart

# Повне очищення
docker compose down -v
docker system prune -a
```

## Отримати допомогу

1. Перевір логи: `docker compose logs`
2. Перевір статус: `docker compose ps`
3. Перевір конфігурацію: `cat docker-compose.yml`
4. Офіційна документація: https://docs.hedgedoc.org/
5. Community форум: https://community.hedgedoc.org/
