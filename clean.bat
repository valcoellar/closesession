@echo off

REM Establecer el tiempo máximo de inactividad en 30 minutos (en segundos)
REM set MAX_IDLE_TIME=1800

REM Establecer el tiempo máximo de inactividad en 10 minutos (en segundos)
set MAX_IDLE_TIME=60


REM Obtener la lista de sesiones activas
net session | findstr /i "Computer User name Client type Opens Idle time" > sessions.txt

REM Procesar cada sesión
for /f "tokens=1-5" %%a in (sessions.txt) do (
    REM Extraer el tiempo de inactividad
    for /f "tokens=1,2 delims=:" %%c in ("%%e") do (
        set /a IDLE_TIME=%%c*60+%%d
        REM Si el tiempo de inactividad es mayor al máximo, cerrar la sesión
        if %IDLE_TIME% gtr %MAX_IDLE_TIME% (
            echo Cerrando sesión inactiva de %%b en %%a
            net session \\%%a /delete
        )
    )
)

del sessions.txt
