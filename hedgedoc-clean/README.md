# HedgeDoc 1.x - Готове рішення для запуску

Це мінімальний пакет для запуску HedgeDoc 1.x (стабільна версія) на різних платформах.

## Що це?

HedgeDoc - це markdown редактор з підтримкою реал-тайм колаборації. Можна створювати нотатки, діаграми, формули і працювати разом з іншими людьми.

## Швидкий старт

### Windows + WSL2 Debian

**Перший раз:**
1. Прочитай [SETUP-WSL.md](SETUP-WSL.md) для повної інструкції
2. Встанови WSL2 + Debian + Docker
3. Подвійний клік на `start-hedgedoc.bat`

**Наступні рази:**
1. Подвійний клік на `start-hedgedoc.bat`
2. Відкрий браузер: http://localhost:3000
3. Готово!

### Linux / Raspberry Pi

**Перший раз:**
1. Прочитай [SETUP-RASPBERRY.md](SETUP-RASPBERRY.md) для повної інструкції
2. Встанови Docker
3. Запусти: `./start-hedgedoc.sh`

**Наступні рази:**
```bash
./start-hedgedoc.sh
```

Відкрий браузер: http://localhost:3000 (або http://IP_ADDRESS:3000)

## Що всередині?

```
hedgedoc-clean/
├── docker-compose.yml          # Конфігурація Docker
├── start-hedgedoc.bat          # Запуск для Windows + WSL2
├── stop-hedgedoc.bat           # Зупинка для Windows + WSL2
├── start-hedgedoc.sh           # Запуск для Linux/Raspberry Pi
├── stop-hedgedoc.sh            # Зупинка для Linux/Raspberry Pi
├── README.md                   # Цей файл
├── SETUP-WSL.md               # Інструкція для WSL2 Debian
└── SETUP-RASPBERRY.md         # Інструкція для Raspberry Pi
```

## Документація

- [Налаштування WSL2 Debian](SETUP-WSL.md) - повна інструкція з нуля
- [Налаштування Raspberry Pi](SETUP-RASPBERRY.md) - інструкція для ARM пристроїв
- [Troubleshooting](TROUBLESHOOTING.md) - вирішення проблем

## Системні вимоги

### Windows + WSL2
- Windows 10/11
- WSL2 з Debian
- 2GB RAM
- 5GB вільного місця

### Raspberry Pi
- Raspberry Pi Zero 2W або новіше
- Raspberry Pi OS (64-bit рекомендовано)
- 1GB RAM мінімум
- 4GB вільного місця

## Можливості

- ✅ Markdown редактор
- ✅ Реал-тайм колаборація
- ✅ Діаграми (Mermaid, PlantUML)
- ✅ Математичні формули (LaTeX)
- ✅ Експорт в PDF/HTML
- ✅ Анонімний доступ
- ✅ Вільні URL

## Підтримка

- Офіційна документація: https://docs.hedgedoc.org/
- GitHub: https://github.com/hedgedoc/hedgedoc
- Community: https://community.hedgedoc.org

---

**Версія:** HedgeDoc 1.10.0  
**Створено:** 2025-11-13  
**Ліцензія:** AGPL-3.0
