@echo off

REM Establecer el tiempo máximo de inactividad en 10 minutos
set MAX_IDLE_TIME_MINS=10

REM Obtener la lista de sesiones activas
net session | findstr /i "Computer User name Client type Opens Idle time" > sessions.txt

REM Procesar cada sesión
for /f "tokens=1-5" %%a in (sessions.txt) do (
    REM Extraer el tiempo de inactividad
    for /f "tokens=1,2 delims=:" %%c in ("%%e") do (
        REM Comprobar si el tiempo de inactividad es mayor a 30 minutos
        if %%c gtr %MAX_IDLE_TIME_MINS% (
            echo Cerrando sesión inactiva de %%b en %%a
            net session \\%%a /delete
        )
    )
)

REM del sessions.txt
