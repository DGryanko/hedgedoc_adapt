# Налаштування HedgeDoc на WSL2 Debian

Повна інструкція з нуля для запуску HedgeDoc на Windows через WSL2 Debian.

## Крок 1: Встановлення WSL2

### 1.1 Увімкнути WSL

Відкрий PowerShell як адміністратор і виконай:

```powershell
wsl --install
```

Перезавантаж комп'ютер.

### 1.2 Встановити Debian

```powershell
wsl --install -d Debian
```

При першому запуску створи username і password.

### 1.3 Перевірити версію WSL

```powershell
wsl --list --verbose
```

Має показати Debian з VERSION 2.

## Крок 2: Встановлення Docker в Debian

### 2.1 Оновити систему

Відкрий WSL Debian:

```bash
wsl -d Debian
```

Оновити пакети:

```bash
sudo apt update
sudo apt upgrade -y
```

### 2.2 Встановити Docker

```bash
# Встановити залежності
sudo apt install -y ca-certificates curl gnupg

# Додати Docker GPG ключ
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Додати Docker репозиторій
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Оновити список пакетів
sudo apt update

# Встановити Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 2.3 Налаштувати Docker для WSL2

Створити конфігураційний файл:

```bash
sudo mkdir -p /etc/docker
echo '{
  "iptables": false,
  "dns": ["8.8.8.8", "8.8.4.4"],
  "userland-proxy": true
}' | sudo tee /etc/docker/daemon.json
```

**Важливо:** 
- `iptables: false` - бо в WSL2 немає kernel модулів для iptables
- `userland-proxy: true` - для проксіювання портів без iptables
- `dns` - для резолвінгу доменних імен

### 2.4 Додати користувача до групи docker

```bash
sudo usermod -aG docker $USER
```

Вийди і зайди знову в WSL:

```bash
exit
wsl -d Debian
```

## Крок 3: Завантажити HedgeDoc

### 3.1 Створити папку для проекту

```bash
mkdir -p ~/hedgedoc
cd ~/hedgedoc
```

### 3.2 Скопіювати файли

Скопіюй всі файли з папки `hedgedoc-clean` в `~/hedgedoc`:

- docker-compose.yml
- start-hedgedoc.sh
- stop-hedgedoc.sh

Або завантаж через git (якщо є репозиторій):

```bash
git clone <repository-url> ~/hedgedoc
cd ~/hedgedoc
```

### 3.3 Зробити скрипти виконуваними

```bash
chmod +x start-hedgedoc.sh stop-hedgedoc.sh
```

## Крок 4: Запустити HedgeDoc

### 4.1 З Windows (рекомендовано)

Подвійний клік на `start-hedgedoc.bat` в папці проекту.

### 4.2 З WSL Debian

```bash
cd ~/hedgedoc
./start-hedgedoc.sh
```

### 4.3 Перевірити статус

```bash
sudo docker compose ps
```

Має показати:
- `hedgedoc-app-1` - STATUS: Up (healthy)
- `hedgedoc-database-1` - STATUS: Up

## Крок 5: Відкрити в браузері

Відкрий браузер на Windows і перейди на:

```
http://localhost:3000
```

Має відкритися інтерфейс HedgeDoc!

## Автоматичний запуск після перезавантаження

### Варіант 1: Батнік на робочому столі

1. Скопіюй `start-hedgedoc.bat` на робочий стіл
2. Подвійний клік для запуску

### Варіант 2: Автозапуск Docker daemon

Додай в `~/.bashrc`:

```bash
echo '# Auto-start Docker daemon
if ! pgrep -x dockerd > /dev/null; then
    sudo dockerd > /dev/null 2>&1 &
fi' >> ~/.bashrc
```

Тепер Docker daemon буде запускатися автоматично при відкритті WSL.

## Troubleshooting

### Проблема: "Cannot connect to Docker daemon"

**Рішення:** Запусти Docker daemon вручну

```bash
sudo dockerd > /dev/null 2>&1 &
```

Зачекай 5 секунд і спробуй знову.

### Проблема: "Порожня біла сторінка в браузері"

**Рішення:** Перевір конфігурацію Docker

```bash
cat /etc/docker/daemon.json
```

Має бути `"userland-proxy": true`. Якщо ні:

```bash
echo '{
  "iptables": false,
  "dns": ["8.8.8.8", "8.8.4.4"],
  "userland-proxy": true
}' | sudo tee /etc/docker/daemon.json

# Перезапусти Docker
sudo pkill dockerd
sudo dockerd > /dev/null 2>&1 &
```

### Проблема: "Port 3000 is already allocated"

**Рішення:** Зупини старі контейнери

```bash
sudo docker ps -a
sudo docker stop <container_id>
```

Або зміни порт в `docker-compose.yml`:

```yaml
ports:
  - "8080:3000"  # Використовувати 8080 замість 3000
```

### Проблема: "Database cannot be reached"

**Рішення:** Перезапусти контейнери

```bash
sudo docker compose down
sudo docker compose up -d
```

## Корисні команди

```bash
# Статус контейнерів
sudo docker compose ps

# Логи
sudo docker compose logs

# Логи в реальному часі
sudo docker compose logs -f

# Перезапустити
sudo docker compose restart

# Зупинити
sudo docker compose down

# Зупинити і видалити дані (ОБЕРЕЖНО!)
sudo docker compose down -v
```

## Backup

### Зробити backup бази даних

```bash
sudo docker compose exec database pg_dump -U hedgedoc hedgedoc > backup_$(date +%Y%m%d).sql
```

### Відновити з backup

```bash
cat backup_20251113.sql | sudo docker compose exec -T database psql -U hedgedoc hedgedoc
```

## Оновлення HedgeDoc

```bash
# Зупинити контейнери
sudo docker compose down

# Завантажити нові образи
sudo docker compose pull

# Запустити з новими образами
sudo docker compose up -d
```

## Видалення

### Видалити контейнери і дані

```bash
cd ~/hedgedoc
sudo docker compose down -v
```

### Видалити Docker

```bash
sudo apt remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
```

---

**Час встановлення:** ~20-30 хвилин  
**Складність:** Середня  
**Підтримка:** https://docs.hedgedoc.org/
