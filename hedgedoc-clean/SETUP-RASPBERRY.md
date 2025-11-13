# Налаштування HedgeDoc на Raspberry Pi

Повна інструкція для запуску HedgeDoc на Raspberry Pi Zero 2W та інших моделях.

## Системні вимоги

### Мінімальні
- Raspberry Pi Zero 2W або новіше
- 512MB RAM (1GB рекомендовано)
- 4GB вільного місця на SD карті
- Raspberry Pi OS (64-bit рекомендовано)

### Рекомендовані
- Raspberry Pi 3B+ або новіше
- 1GB+ RAM
- 8GB+ вільного місця
- Ethernet підключення (для стабільності)

## Крок 1: Підготовка Raspberry Pi

### 1.1 Встановити Raspberry Pi OS

1. Завантаж [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
2. Вибери OS: **Raspberry Pi OS (64-bit)** (рекомендовано)
3. Запиши на SD карту
4. Увімкни Raspberry Pi

### 1.2 Оновити систему

```bash
sudo apt update
sudo apt upgrade -y
```

### 1.3 Налаштувати swap (для моделей з малою RAM)

Якщо у тебе Raspberry Pi Zero 2W або інша модель з малою RAM:

```bash
# Збільшити swap до 2GB
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
```

Зміни `CONF_SWAPSIZE=100` на `CONF_SWAPSIZE=2048`

```bash
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

## Крок 2: Встановлення Docker

### 2.1 Встановити Docker

```bash
# Завантажити і запустити офіційний скрипт встановлення
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### 2.2 Додати користувача до групи docker

```bash
sudo usermod -aG docker $USER
```

Вийди і зайди знову:

```bash
exit
# Підключись знову через SSH або відкрий новий термінал
```

### 2.3 Перевірити встановлення

```bash
docker --version
docker compose version
```

### 2.4 Увімкнути автозапуск Docker

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

## Крок 3: Завантажити HedgeDoc

### 3.1 Створити папку для проекту

```bash
mkdir -p ~/hedgedoc
cd ~/hedgedoc
```

### 3.2 Створити docker-compose.yml

```bash
nano docker-compose.yml
```

Вставити:

```yaml
services:
  database:
    image: postgres:13.4-alpine
    environment:
      - POSTGRES_USER=hedgedoc
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=hedgedoc
    volumes:
      - database:/var/lib/postgresql/data
    restart: always
    networks:
      hedgedoc-net:
        ipv4_address: 172.20.0.2

  app:
    image: quay.io/hedgedoc/hedgedoc:1.10.0
    environment:
      - CMD_DB_URL=postgres://hedgedoc:password@172.20.0.2:5432/hedgedoc
      - CMD_DOMAIN=localhost
      - CMD_URL_ADDPORT=true
      - CMD_PORT=3000
      - CMD_PROTOCOL_USESSL=false
      - CMD_ALLOW_ANONYMOUS=true
      - CMD_ALLOW_ANONYMOUS_EDITS=true
      - CMD_ALLOW_FREEURL=true
    volumes:
      - uploads:/hedgedoc/public/uploads
    ports:
      - "3000:3000"
    restart: always
    depends_on:
      - database
    extra_hosts:
      - "database:172.20.0.2"
    networks:
      hedgedoc-net:
        ipv4_address: 172.20.0.3

volumes:
  database:
  uploads:

networks:
  hedgedoc-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

Збережи: `Ctrl+O`, `Enter`, `Ctrl+X`

### 3.3 Створити скрипти запуску

```bash
# Скрипт запуску
cat > start-hedgedoc.sh << 'EOF'
#!/bin/bash
echo "Starting HedgeDoc..."
docker compose up -d
echo "HedgeDoc is starting! Wait 30 seconds..."
sleep 30
docker compose ps
echo ""
echo "Open in browser: http://$(hostname -I | awk '{print $1}'):3000"
EOF

# Скрипт зупинки
cat > stop-hedgedoc.sh << 'EOF'
#!/bin/bash
echo "Stopping HedgeDoc..."
docker compose down
echo "HedgeDoc stopped!"
EOF

# Зробити виконуваними
chmod +x start-hedgedoc.sh stop-hedgedoc.sh
```

## Крок 4: Запустити HedgeDoc

### 4.1 Перший запуск

```bash
cd ~/hedgedoc
./start-hedgedoc.sh
```

**Важливо:** Перший запуск може зайняти 5-15 хвилин, бо Docker завантажує образи.

На Raspberry Pi Zero 2W може зайняти до 30 хвилин!

### 4.2 Перевірити статус

```bash
docker compose ps
```

Має показати:
- `hedgedoc-app-1` - STATUS: Up (healthy)
- `hedgedoc-database-1` - STATUS: Up

### 4.3 Подивитись логи

```bash
docker compose logs -f
```

Натисни `Ctrl+C` щоб вийти.

## Крок 5: Відкрити в браузері

### 5.1 Дізнатись IP адресу Raspberry Pi

```bash
hostname -I
```

Наприклад: `192.168.1.100`

### 5.2 Відкрити в браузері

На будь-якому пристрої в локальній мережі відкрий:

```
http://192.168.1.100:3000
```

(Замість 192.168.1.100 використай свою IP адресу)

## Крок 6: Автозапуск після перезавантаження

### 6.1 Створити systemd service

```bash
sudo nano /etc/systemd/system/hedgedoc.service
```

Вставити:

```ini
[Unit]
Description=HedgeDoc
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/pi/hedgedoc
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
User=pi

[Install]
WantedBy=multi-user.target
```

**Важливо:** Зміни `User=pi` на свого користувача, якщо інший.

### 6.2 Увімкнути автозапуск

```bash
sudo systemctl enable hedgedoc.service
sudo systemctl start hedgedoc.service
```

### 6.3 Перевірити статус

```bash
sudo systemctl status hedgedoc.service
```

Тепер HedgeDoc буде запускатися автоматично після перезавантаження!

## Оптимізація для Raspberry Pi Zero 2W

### Зменшити використання RAM

Додай в `docker-compose.yml` обмеження пам'яті:

```yaml
services:
  database:
    # ... інші налаштування
    mem_limit: 256m
    
  app:
    # ... інші налаштування
    mem_limit: 512m
```

### Використовувати легший образ PostgreSQL

Зміни в `docker-compose.yml`:

```yaml
database:
  image: postgres:13-alpine  # Замість postgres:13.4-alpine
```

## Доступ з інтернету (опціонально)

### Варіант 1: Cloudflare Tunnel (безкоштовно)

1. Зареєструйся на [Cloudflare](https://www.cloudflare.com/)
2. Встанови cloudflared:

```bash
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb
sudo dpkg -i cloudflared-linux-arm64.deb
```

3. Налаштуй tunnel:

```bash
cloudflared tunnel login
cloudflared tunnel create hedgedoc
cloudflared tunnel route dns hedgedoc hedgedoc.yourdomain.com
```

4. Запусти tunnel:

```bash
cloudflared tunnel run hedgedoc
```

### Варіант 2: Port Forwarding на роутері

1. Відкрий адмін панель роутера (зазвичай 192.168.1.1)
2. Знайди "Port Forwarding" або "Virtual Server"
3. Додай правило:
   - External Port: 3000
   - Internal IP: IP твого Raspberry Pi
   - Internal Port: 3000
   - Protocol: TCP

4. Дізнайся свій зовнішній IP:

```bash
curl ifconfig.me
```

5. Відкрий в браузері: `http://YOUR_EXTERNAL_IP:3000`

**Увага:** Це небезпечно без HTTPS! Використовуй тільки для тестування.

## Troubleshooting

### Проблема: "Контейнери не запускаються"

**Рішення:** Перевір логи

```bash
docker compose logs
```

Якщо бачиш "Out of memory", збільш swap (див. Крок 1.3).

### Проблема: "Дуже повільно працює"

**Рішення для Raspberry Pi Zero 2W:**

1. Збільш swap до 2GB
2. Використовуй SD карту класу 10 або вище
3. Обмеж пам'ять контейнерів (див. Оптимізація)
4. Закрий інші програми

### Проблема: "Cannot reach database"

**Рішення:** Зачекай довше

На Raspberry Pi Zero 2W база даних може запускатися 2-5 хвилин.

```bash
# Подивись логи бази даних
docker compose logs database
```

### Проблема: "Port 3000 is already in use"

**Рішення:** Зміни порт

В `docker-compose.yml`:

```yaml
ports:
  - "8080:3000"  # Використовувати 8080
```

## Моніторинг

### Подивитись використання ресурсів

```bash
docker stats
```

### Подивитись температуру CPU

```bash
vcgencmd measure_temp
```

Якщо > 70°C, додай радіатор або кулер.

## Backup

### Автоматичний backup щодня

```bash
# Створити скрипт backup
cat > ~/backup-hedgedoc.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/hedgedoc-backups
mkdir -p $BACKUP_DIR
cd ~/hedgedoc
docker compose exec -T database pg_dump -U hedgedoc hedgedoc > $BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql
# Видалити backup старіші 7 днів
find $BACKUP_DIR -name "backup_*.sql" -mtime +7 -delete
EOF

chmod +x ~/backup-hedgedoc.sh
```

Додати в crontab:

```bash
crontab -e
```

Додати рядок:

```
0 2 * * * /home/pi/backup-hedgedoc.sh
```

Тепер backup буде створюватися щодня о 2:00 ночі.

## Корисні команди

```bash
# Статус
docker compose ps

# Логи
docker compose logs -f

# Перезапустити
docker compose restart

# Зупинити
docker compose down

# Оновити образи
docker compose pull
docker compose up -d

# Використання диску
df -h
docker system df
```

## Продуктивність

### Очікувана продуктивність

| Модель | Час запуску | Час відгуку | Одночасних користувачів |
|--------|-------------|-------------|-------------------------|
| Pi Zero 2W | 5-10 хв | 2-5 сек | 1-2 |
| Pi 3B+ | 2-5 хв | 1-2 сек | 3-5 |
| Pi 4 (2GB) | 1-3 хв | <1 сек | 5-10 |
| Pi 4 (4GB+) | 1-2 хв | <1 сек | 10-20 |

## Видалення

```bash
cd ~/hedgedoc
docker compose down -v
cd ~
rm -rf hedgedoc
```

---

**Час встановлення:** 30-60 хвилин (залежно від моделі)  
**Складність:** Середня  
**Підтримка:** https://docs.hedgedoc.org/
