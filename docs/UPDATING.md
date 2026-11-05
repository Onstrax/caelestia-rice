# Actualización de Caelestia frente a upstream

**Política aprobada:** rama única personal `juanes-rice`; rama única `main` en `dotfiles-rice`. No crear ramas históricas, ni actualizar upstream sin revisión previa, ni perder el canon funcional.

## 1. Situación conocida

```text
origin    git@github.com:Onstrax/caelestia-rice.git
upstream  https://github.com/caelestia-dots/shell.git
rama local y default de origin: juanes-rice
```

La presencia de muchas referencias `upstream/*` es normal: son ramas del proyecto original, no de tu fork.

## 2. Inspeccionar cambios sin integrarlos

```fish
set -l repo ~/.config/quickshell/caelestia
git -C "$repo" status -sb
git -C "$repo" fetch upstream
git -C "$repo" log --oneline --left-right juanes-rice...upstream/main | head -50
git -C "$repo" diff --stat juanes-rice upstream/main
```

Leer la lista de cambios y las alteraciones de componentes personalizados antes de intentar compilar. Si Git muestra diferencias enormes, **no** significa que haya que reemplazar toda la rama personal.

## 3. Integrar: plan, no comando automático

1. Asegurar que ambos repositorios estén limpios y publicados.
2. Confirmar que existe copia válida `rice-master`; para mantenimiento mayor, contar con la generación rotativa pertinente.
3. Comparar código personal con upstream y escoger cambios concretos que se necesitan.
4. Editar o integrar manualmente; revisar conflictos en QML/CMake/servicios.
5. Compilar con la configuración CMake **de esta versión**, no con opciones copiadas de otra release.
6. Probar interface, arranque, TimerTab, RunCat, festivos, dashboard, bloqueo, audio, notificaciones y scripts.
7. Commit selectivo en `juanes-rice`, push, y actualizar `rice-master` una vez aprobado.

**No ejecutar** `git reset --hard upstream/main`, `git pull upstream main`, `git push --force` ni el instalador upstream sobre la configuración activa sin comparar qué borrarían.

## 4. Sistema legado de parches

Existe `~/dotfiles-rice/caelestia-config/patches/caelestia-rice/apply-rice-patches.sh`, que ofrece siete grupos de parches. Está versionado, pero **no es necesario** para sincronizar el canon ya funcionando. Su ejecución es interactiva y crea respaldos en `~/backups-rice/rice-patches/`, ajenos a los dos directorios locales aprobados. Usar solo si se decide conscientemente recuperar cambios sobre una versión nueva y revisar sus consecuencias.

## 5. Diagnóstico

```fish
hyprctl configerrors
pgrep -af 'qs -c caelestia'
git -C ~/.config/quickshell/caelestia status -sb
# Comprobar si el CLI está presente:
command -v caelestia
command -v qs
```

Para el método original de construcción, conservar el README upstream que ya vive en la raíz del repositorio, además de esta guía personal.
