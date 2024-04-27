@echo off
setlocal EnableDelayedExpansion

REM Establecer el tiempo máximo de inactividad en 10 minutos (en segundos)
set MAX_IDLE_TIME=600

REM Obtener la lista de sesiones activas
net session > sessions.txt

REM Procesar cada sesión
for /f "skip=4 tokens=1-5" %%a in (sessions.txt) do (
    REM Extraer el tiempo de inactividad
    for /f "tokens=4,5" %%c in ("%%e") do (
        REM Convertir el tiempo de inactividad en segundos
        set "IDLE_TIME=%%c"
        set /a "IDLE_TIME=!IDLE_TIME:~0,2!*3600+!IDLE_TIME:~3,2!*60+!IDLE_TIME:~6,2!"
        
        REM Si el tiempo de inactividad es mayor al máximo, cerrar la sesión
        if !IDLE_TIME! gtr %MAX_IDLE_TIME% (
            echo Cerrando sesión inactiva de %%b en %%a
            net session \\%%a /delete
        )
    )
)

del sessions.txt
