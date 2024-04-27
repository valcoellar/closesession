@echo off
setlocal EnableDelayedExpansion

REM Establecer el tiempo máximo de inactividad en 10 minutos (en segundos)
set MAX_IDLE_TIME=600

REM Obtener la lista de sesiones activas
net session > sessions.txt

REM Procesar cada sesión
for /f "skip=4 tokens=1-5" %%a in (sessions.txt) do (
    REM Extraer el tiempo de inactividad
    for /f "tokens=4" %%c in ("%%e") do (
        REM Reemplazar los puntos por espacios para que el tiempo de inactividad sea más fácil de procesar
        set "IDLE_TIME=%%c"
        set "IDLE_TIME=!IDLE_TIME:.= !"

        REM Convertir el tiempo de inactividad en segundos
        for /f "tokens=1-3 delims= " %%d in ("!IDLE_TIME!") do (
            set /a "IDLE_TIME=(%%d*3600)+(%%e*60)+(%%f)"
        )

        REM Si el tiempo de inactividad es mayor o igual al máximo, cerrar la sesión
        if !IDLE_TIME! geq %MAX_IDLE_TIME% (
            echo Cerrando sesión inactiva de %%b en %%a
            net session \\%%a /delete
        )
    )
)

del sessions.txt
