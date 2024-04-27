@echo off
setlocal EnableDelayedExpansion

REM Establecer el tiempo máximo de inactividad en 10 minutos (en segundos)
set MAX_IDLE_TIME=600

REM Obtener la lista de sesiones activas
net session > sessions.txt

REM Procesar cada sesión
for /f "skip=4 tokens=1-5" %%a in (sessions.txt) do (
    REM Extraer el tiempo de inactividad
    for /f "tokens=1,2 delims=:" %%c in ("%%e") do (
        set /a IDLE_TIME=%%c*60+%%d
        REM Si el tiempo de inactividad es mayor al máximo, cerrar la sesión
        set /a IS_IDLE=!IDLE_TIME! gtr !MAX_IDLE_TIME!
        if !IS_IDLE! equ 1 (
            echo Cerrando sesión inactiva de %%b en %%a
            net session \\%%a /delete
        )
    )
)

del sessions.txt
