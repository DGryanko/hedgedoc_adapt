# Повна інструкція по роботі з Docker в Debian WSL2

## Зміст
1. [Основні команди Docker](#основні-команди-docker)
2. [Робота з контейнерами](#робота-з-контейнерами)
3. [Робота з образами](#робота-з-образами)
4. [Docker Compose](#docker-compose)
5. [Мережі Docker](#мережі-docker)
6. [Volumes (Томи)](#volumes-томи)
7. [Корисні поради](#корисні-поради)
8. [Troubleshooting](#troubleshooting)

---

## Основні команди Docker

### Запуск Docker daemon
```bash
# Запустити Docker daemon (потрібно робити після кожного перезапуску WSL)
sudo dockerd > /dev/null 2>&1 &

# Перевірити статус
sudo docker ps

# Перевірити версію
docker --version
docker compose version
```

### Інформація про систему
```bash
# Загальна інформація про Docker
docker info

# Використання диску
docker system df

# Детальна інформація про використання
docker system df -v
```

---

## Робота з контейнерами

### Перегляд контейнерів
```bash
# Показати запущені контейнери
docker ps

# Показати всі контейнери (включно зі зупиненими)
docker ps -a

# Показати тільки ID контейнерів
docker ps -q

# Показати останній створений контейнер
docker ps -l
```

### Запуск контейнерів
```bash
# Запустити контейнер з образу
docker run nginx

# Запустити в фоновому режимі (-d = detached)
docker run -d nginx

# Запустити з іменем
docker run -d --name my-nginx nginx

# Запустити з портами (host:container)
docker run -d -p 8080:80 nginx

# Запустити з змінними середовища
docker run -d -e "ENV_VAR=value" nginx

# Запустити з volume
docker run -d -v /host/path:/container/path nginx

# Запустити інтерактивно з терміналом
docker run -it ubuntu bash

# Запустити і видалити після зупинки
docker run --rm nginx
```

### Управління контейнерами
```bash
# Зупинити контейнер
docker stop container_name_or_id

# Зупинити всі контейнери
docker stop $(docker ps -q)

# Запустити зупинений контейнер
docker start container_name_or_id

# Перезапустити контейнер
docker restart container_name_or_id

# Призупинити контейнер (pause)
docker pause container_name_or_id

# Відновити призупинений контейнер
docker unpause container_name_or_id

# Видалити контейнер (спочатку треба зупинити)
docker rm container_name_or_id

# Видалити контейнер примусово (навіть якщо запущений)
docker rm -f container_name_or_id

# Видалити всі зупинені контейнери
docker container prune
```

### Інформація про контейнери
```bash
# Детальна інформація про контейнер
docker inspect container_name_or_id

# Логи контейнера
docker logs container_name_or_id

# Логи в реальному часі (як tail -f)
docker logs -f container_name_or_id

# Останні 100 рядків логів
docker logs --tail 100 container_name_or_id

# Статистика використання ресурсів
docker stats

# Статистика конкретного контейнера
docker stats container_name_or_id

# Процеси всередині контейнера
docker top container_name_or_id
```

### Робота всередині контейнера
```bash
# Виконати команду в запущеному контейнері
docker exec container_name_or_id ls -la

# Відкрити bash в контейнері
docker exec -it container_name_or_id bash

# Або sh, якщо bash недоступний
docker exec -it container_name_or_id sh

# Виконати команду як root
docker exec -u root -it container_name_or_id bash

# Копіювати файли з контейнера на хост
docker cp container_name:/path/to/file /host/path

# Копіювати файли з хоста в контейнер
docker cp /host/path/file container_name:/path/to/
```

---

## Робота з образами

### Перегляд образів
```bash
# Показати всі образи
docker images

# Показати образи з фільтром
docker images nginx

# Показати тільки ID образів
docker images -q
```

### Завантаження образів
```bash
# Завантажити образ з Docker Hub
docker pull nginx

# Завантажити конкретну версію (тег)
docker pull nginx:1.25

# Завантажити з іншого registry
docker pull ghcr.io/hedgedoc/hedgedoc:latest
```

### Створення образів
```bash
# Створити образ з Dockerfile в поточній директорії
docker build -t my-image:tag .

# Створити образ з конкретного Dockerfile
docker build -t my-image:tag -f Dockerfile.custom .

# Створити образ без кешу
docker build --no-cache -t my-image:tag .

# Створити образ з контейнера
docker commit container_name my-new-image:tag
```

### Управління образами
```bash
# Видалити образ
docker rmi image_name_or_id

# Видалити образ примусово
docker rmi -f image_name_or_id

# Видалити всі невикористовувані образи
docker image prune

# Видалити всі образи
docker rmi $(docker images -q)

# Додати тег до образу
docker tag source_image:tag target_image:tag

# Інформація про образ
docker inspect image_name_or_id

# Історія створення образу (шари)
docker history image_name_or_id
```

### Робота з Docker Hub
```bash
# Увійти в Docker Hub
docker login

# Вийти
docker logout

# Завантажити образ на Docker Hub
docker push username/image_name:tag

# Пошук образів
docker search nginx
```

---

## Docker Compose

### Основні команди
```bash
# Запустити всі сервіси (з docker-compose.yml)
docker compose up

# Запустити в фоновому режимі
docker compose up -d

# Запустити конкретний сервіс
docker compose up service_name

# Зупинити всі сервіси
docker compose down

# Зупинити і видалити volumes
docker compose down -v

# Зупинити без видалення контейнерів
docker compose stop

# Запустити зупинені сервіси
docker compose start

# Перезапустити сервіси
docker compose restart

# Перезібрати образи і запустити
docker compose up -d --build

# Використати інший файл compose
docker compose -f docker-compose.custom.yml up -d
```

### Перегляд інформації
```bash
# Показати запущені сервіси
docker compose ps

# Показати всі сервіси (включно зі зупиненими)
docker compose ps -a

# Логи всіх сервісів
docker compose logs

# Логи конкретного сервісу
docker compose logs service_name

# Логи в реальному часі
docker compose logs -f

# Останні 100 рядків
docker compose logs --tail=100

# Виконати команду в сервісі
docker compose exec service_name bash

# Перевірити конфігурацію
docker compose config

# Показати образи, які використовуються
docker compose images
```

### Масштабування
```bash
# Запустити кілька екземплярів сервісу
docker compose up -d --scale service_name=3

# Зменшити кількість екземплярів
docker compose up -d --scale service_name=1
```

---

## Мережі Docker

### Перегляд мереж
```bash
# Показати всі мережі
docker network ls

# Детальна інформація про мережу
docker network inspect network_name

# Показати, які контейнери підключені до мережі
docker network inspect network_name | grep -A 10 Containers
```

### Управління мережами
```bash
# Створити мережу
docker network create my-network

# Створити мережу з підмережею
docker network create --subnet=172.20.0.0/16 my-network

# Підключити контейнер до мережі
docker network connect network_name container_name

# Відключити контейнер від мережі
docker network disconnect network_name container_name

# Видалити мережу
docker network rm network_name

# Видалити всі невикористовувані мережі
docker network prune
```

### Типи мереж
```bash
# Bridge (за замовчуванням) - для зв'язку контейнерів на одному хості
docker network create --driver bridge my-bridge

# Host - контейнер використовує мережу хоста
docker run --network host nginx

# None - без мережі
docker run --network none nginx
```

---

## Volumes (Томи)

### Перегляд volumes
```bash
# Показати всі volumes
docker volume ls

# Детальна інформація про volume
docker volume inspect volume_name
```

### Управління volumes
```bash
# Створити volume
docker volume create my-volume

# Використати volume при запуску контейнера
docker run -d -v my-volume:/data nginx

# Використати bind mount (прив'язка до директорії хоста)
docker run -d -v /host/path:/container/path nginx

# Використати bind mount тільки для читання
docker run -d -v /host/path:/container/path:ro nginx

# Видалити volume
docker volume rm volume_name

# Видалити всі невикористовувані volumes
docker volume prune

# Видалити всі volumes (ОБЕРЕЖНО!)
docker volume rm $(docker volume ls -q)
```

---

## Корисні поради

### Очищення системи
```bash
# Видалити всі зупинені контейнери, невикористовувані мережі, образи та build cache
docker system prune

# Те саме + volumes
docker system prune -a --volumes

# Видалити тільки старі образи (dangling)
docker image prune

# Видалити всі невикористовувані образи
docker image prune -a
```

### Моніторинг
```bash
# Статистика в реальному часі
docker stats

# Подивитись, скільки місця займає Docker
docker system df

# Події Docker в реальному часі
docker events

# Фільтрувати події
docker events --filter 'type=container'
```

### Експорт/Імпорт
```bash
# Зберегти образ у файл
docker save -o my-image.tar image_name:tag

# Завантажити образ з файлу
docker load -i my-image.tar

# Експортувати контейнер у файл
docker export container_name > container.tar

# Імпортувати контейнер з файлу
docker import container.tar new-image:tag
```

### Dockerfile - основи
```dockerfile
# Приклад простого Dockerfile
FROM ubuntu:22.04

# Встановити пакети
RUN apt-get update && apt-get install -y nginx

# Копіювати файли
COPY ./app /var/www/html

# Встановити робочу директорію
WORKDIR /var/www/html

# Відкрити порт
EXPOSE 80

# Команда за замовчуванням
CMD ["nginx", "-g", "daemon off;"]
```

---

## Troubleshooting

### Docker daemon не запускається
```bash
# Перевірити, чи запущений daemon
ps aux | grep dockerd

# Запустити вручну з логами
sudo dockerd

# Перевірити логи systemd (якщо використовується)
sudo journalctl -u docker

# Перезапустити WSL
wsl --shutdown
# Потім знову відкрити WSL
```

### Проблеми з правами доступу
```bash
# Додати користувача до групи docker
sudo usermod -aG docker $USER

# Застосувати зміни (або перезайти)
newgrp docker

# Перевірити
docker ps
```

### Контейнер не запускається
```bash
# Подивитись логи
docker logs container_name

# Подивитись детальну інформацію
docker inspect container_name

# Спробувати запустити інтерактивно
docker run -it image_name bash
```

### Проблеми з мережею
```bash
# Перевірити мережі
docker network ls

# Перевірити IP контейнера
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name

# Перевірити з'єднання між контейнерами
docker exec container1 ping container2

# Перезапустити Docker daemon
sudo pkill dockerd
sudo dockerd > /dev/null 2>&1 &
```

### Очистити все і почати заново
```bash
# ОБЕРЕЖНО! Це видалить ВСЕ
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker volume rm $(docker volume ls -q)
docker network prune -f
docker system prune -a --volumes -f
```

---

## Специфіка для твого WSL2 Debian

### Запуск Docker після перезапуску WSL
```bash
# Завжди потрібно запускати daemon вручну
sudo dockerd > /dev/null 2>&1 &

# Або додати в ~/.bashrc для автозапуску
echo 'sudo dockerd > /dev/null 2>&1 &' >> ~/.bashrc
```

### Твоя конфігурація з iptables
```bash
# У тебе вимкнено iptables в /etc/docker/daemon.json
# Тому використовуються фіксовані IP адреси в docker-compose.yml
# Це нормально для WSL2 без iptables
```

### Доступ до контейнерів з Windows
```bash
# Контейнери доступні через localhost з Windows
# Наприклад: http://localhost:3000 для HedgeDoc
# Або через IP WSL: http://172.x.x.x:3000
```

---

## Корисні посилання

- Офіційна документація: https://docs.docker.com/
- Docker Hub: https://hub.docker.com/
- Docker Compose документація: https://docs.docker.com/compose/
- Dockerfile reference: https://docs.docker.com/engine/reference/builder/

---

**Створено:** 2025-11-13  
**Для:** WSL2 Debian з Docker Engine (без Docker Desktop)
