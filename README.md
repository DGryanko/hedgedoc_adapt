# HedgeDoc 1.x - Готове рішення

Мінімальний пакет для запуску HedgeDoc 1.x (стабільна версія) на Windows WSL2 Debian або Raspberry Pi.

## 🚀 Швидкий старт

### Windows + WSL2 Debian

```
Подвійний клік на: hedgedoc-clean/start-hedgedoc.bat
```

Відкрий: http://localhost:3000

### Linux / Raspberry Pi

```bash
cd hedgedoc-clean
./start-hedgedoc.sh
```

Відкрий: http://localhost:3000

## 📁 Структура проекту

```
hedgedoc/
├── hedgedoc-clean/                 ⭐ ВСЕ ЩО ПОТРІБНО ТУТ
│   ├── docker-compose.yml          # Конфігурація Docker
│   ├── start-hedgedoc.bat          # Запуск Windows + WSL2
│   ├── stop-hedgedoc.bat           # Зупинка Windows + WSL2
│   ├── start-hedgedoc.sh           # Запуск Linux/Raspberry Pi
│   ├── stop-hedgedoc.sh            # Зупинка Linux/Raspberry Pi
│   ├── README.md                   # Загальна інформація
│   ├── SETUP-WSL.md               # Інструкція WSL2 з нуля (20-30 хв)
│   ├── SETUP-RASPBERRY.md         # Інструкція Raspberry Pi з нуля (30-60 хв)
│   └── TROUBLESHOOTING.md         # Вирішення проблем
│
├── docs-history/                   # Історія розробки (можна видалити)
└── README.md                       # Цей файл
```

## 📦 Встановлення на нову машину

### Варіант 1: Тільки необхідне (рекомендовано)

Скопіюй тільки папку `hedgedoc-clean/` на нову машину - це все що потрібно!

```bash
# Приклад для Linux/Raspberry Pi
scp -r hedgedoc-clean/ user@new-machine:~/
```

### Варіант 2: Весь проект

Скопіюй всю папку `hedgedoc/` якщо хочеш зберегти історію розробки.

## 📚 Документація

Вся необхідна документація знаходиться в папці `hedgedoc-clean/`:

1. **[hedgedoc-clean/README.md](hedgedoc-clean/README.md)** - загальна інформація
2. **[hedgedoc-clean/SETUP-WSL.md](hedgedoc-clean/SETUP-WSL.md)** - інструкція WSL2 з нуля (20-30 хв)
3. **[hedgedoc-clean/SETUP-RASPBERRY.md](hedgedoc-clean/SETUP-RASPBERRY.md)** - інструкція Raspberry Pi з нуля (30-60 хв)
4. **[hedgedoc-clean/TROUBLESHOOTING.md](hedgedoc-clean/TROUBLESHOOTING.md)** - вирішення проблем

**Історія розробки:** Папка `docs-history/` містить додаткову документацію та історію вирішення проблем (можна видалити)

## Що це?

HedgeDoc - це markdown редактор з підтримкою реал-тайм колаборації.

**Можливості:**
- ✅ Markdown редактор
- ✅ Реал-тайм колаборація
- ✅ Діаграми (Mermaid, PlantUML)
- ✅ Математичні формули (LaTeX)
- ✅ Експорт в PDF/HTML
- ✅ Анонімний доступ

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

## Підтримка

- Офіційна документація: https://docs.hedgedoc.org/
- GitHub: https://github.com/hedgedoc/hedgedoc
- Community: https://community.hedgedoc.org

---

**Версія:** HedgeDoc 1.10.0  
**Дата:** 2025-11-13  
**Статус:** ✅ Готово до використання
