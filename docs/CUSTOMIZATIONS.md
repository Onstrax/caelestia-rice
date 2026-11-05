# Personalizaciones de la shell Quickshell

## Repositorios

- Canon QML: `~/.config/quickshell/caelestia` → `Onstrax/caelestia-rice`, rama `juanes-rice`.
- Canon personal: `~/dotfiles-rice`, rama `main`, con `caelestia-config/hypr-user*.lua`, `shell.json`, scripts y parches opcionales.
- Proyecto base: remoto `upstream` → `https://github.com/caelestia-dots/shell.git`. Las ramas remotas `upstream/*` **no son** ramas adicionales de tu fork.

## Módulos propios observados

| Funcionalidad | Archivos actuales QML (ejemplos) |
|---|---|
| Reloj/RunCat/barra | `modules/bar/Bar.qml`, `modules/bar/components/Clock.qml`, `modules/bar/components/RunCat.qml` |
| Dashboard y TimerTab | `modules/dashboard/Content.qml`, `modules/dashboard/TimerTab.qml`, `modules/dashboard/dash/DateTime.qml` |
| Rendimiento CPU/GPU/red | `modules/dashboard/performance/HeroCard.qml`, `NetworkCard.qml`, `services/SystemUsage.qml` |
| Festivos de Colombia | `services/ColombiaHolidays.qml`, `modules/dashboard/dash/Calendar.qml` |
| Sesión y notificaciones | `modules/session/Content.qml`, `modules/drawers/Interactions.qml` |
| Temporizador/estado | `services/TimerState.qml`, `scripts/timer_finished.sh` |
| Detalles de conectividad | `modules/nexus/pages/network/`, `services/Nmcli.qml` |

Esta es una **cartografía de archivos presentes en el commit canónico `309631c4`**, no una lista completa y demostrada de diferencias frente a upstream. Antes de documentar una modificación de código concreta, comparar el archivo de la rama personal con su homólogo en el upstream fijado.

## Qué NO se modifica aquí

- Distribución `latam,us`, `Super+Espacio`, binds de luces, multimedia y RGB: repositorio **dotfiles-rice**, módulos Lua.
- Regla VS Code workspace 2: `dotfiles-rice/caelestia-config/hypr-user/workspace-rules.lua`.
- Autostart: `dotfiles-rice/caelestia-config/scripts/autostart.sh`.
- Opciones normales de Caelestia: `dotfiles-rice/caelestia-config/shell.json`.

## Comprobación de interfaz

```fish
git -C ~/.config/quickshell/caelestia status -sb
pgrep -af 'qs -c caelestia'
hyprctl configerrors
```

No borrar `build/`, `lib/` ni sobrescribir `/etc/xdg/quickshell/caelestia` durante una exploración. Son recursos de ejecución/instalación, aunque no formen parte del Git de fuentes.
