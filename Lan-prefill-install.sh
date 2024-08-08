#!/bin/bash

# Actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Instalar las dependencias requeridas
sudo apt install -y curl jq unzip wget apt-transport-https ca-certificates software-properties-common docker-compose docker.io

# Clonar el nuevo repositorio de Lan-Prefill
git clone https://github.com/xodaaaa/Lan-Prefill lancache

# Cambiar al directorio del repositorio clonado
cd lancache

# Función para solicitar un parámetro al usuario
ask_parameter() {
    local param_name=$1
    local default_value=$2
    local user_input

    read -p "Ingrese el valor para $param_name [$default_value]: " user_input
    echo ${user_input:-$default_value}
}

# Solicitar parámetros al usuario
LANCACHE_IP=$(ask_parameter "LANCACHE_IP" "0.0.0.0")
DNS_BIND_IP=$(ask_parameter "DNS_BIND_IP" "0.0.0.0")

# Actualizar el archivo .env con los nuevos valores
sed -i "s/^LANCACHE_IP=.*/LANCACHE_IP=$LANCACHE_IP/" .env
sed -i "s/^DNS_BIND_IP=.*/DNS_BIND_IP=$DNS_BIND_IP/" .env

echo "El archivo .env ha sido actualizado con los siguientes valores:"
echo "LANCACHE_IP=$LANCACHE_IP"
echo "DNS_BIND_IP=$DNS_BIND_IP"
echo "Los demás parámetros se han mantenido con sus valores por defecto."

# Ejecutar docker-compose
echo "Iniciando los contenedores con docker-compose..."
docker-compose up -d

# Verificar que los contenedores estén en ejecución
echo "Verificando el estado de los contenedores..."
if [ $(docker-compose ps -q | wc -l) -eq 3 ]; then
    echo "Los 3 contenedores están en ejecución."
    
    # Obtener los IDs de los contenedores y actualizar la política de reinicio
    echo "Actualizando la política de reinicio de los contenedores..."
    docker-compose ps -q | xargs -I {} docker update --restart always {}
    
    echo "La política de reinicio ha sido actualizada para todos los contenedores."
else
    echo "Error: No se han iniciado los 3 contenedores esperados."
    echo "Por favor, revise los logs de docker-compose para más información."
fi

# Checkpoint
echo "Checkpoint alcanzado: El script ha completado la configuración inicial de Lan-Prefill."
echo "Los contenedores han sido iniciados y configurados para reinicio automático."

# Configuración de SteamPrefill
echo "Configurando SteamPrefill..."

# Volver al directorio padre
cd ..

# Crear y entrar al directorio SteamPrefill
mkdir SteamPrefill
cd SteamPrefill/

# Descargar el script de actualización
echo "Descargando el script de actualización..."
curl -o update.sh --location "https://raw.githubusercontent.com/xodaaaa/Lan-Prefill/main/update.sh"

# Hacer ejecutable el script de actualización
chmod +x update.sh

# Ejecutar el script de actualización
echo "Ejecutando el script de actualización..."
./update.sh

# Hacer ejecutable SteamPrefill
chmod +x ./SteamPrefill

echo "Configuración de SteamPrefill completada."

# Función para ejecutar SteamPrefill
run_steamprefill() {
    echo "Ejecutando SteamPrefill..."
    echo "Por favor, siga las instrucciones en pantalla para seleccionar y precargar juegos."
    echo "Cuando haya terminado, el script principal continuará."
    echo "Presione Enter para comenzar..."
    read

    ./SteamPrefill select-apps

    echo "SteamPrefill ha terminado. Presione Enter para continuar con el script principal..."
    read
}

# Preguntar al usuario si desea ejecutar SteamPrefill
while true; do
    read -p "¿Desea ejecutar SteamPrefill para precargar juegos ahora? (s/n): " choice
    case "$choice" in 
        s|S ) run_steamprefill; break;;
        n|N ) echo "Saltando la ejecución de SteamPrefill."; break;;
        * ) echo "Por favor, responda con 's' o 'n'.";;
    esac
done

# Crear el archivo timer de systemd
echo "Creando el archivo steamprefill.timer..."
cat << EOF | sudo tee /etc/systemd/system/steamprefill.timer > /dev/null
[Unit]
Description=SteamPrefill run daily
Requires=steamprefill.service

[Timer]
# Runs every day at 4am (local time)
OnCalendar=*-*-* 4:00:00

# Set to true so we can store when the timer last triggered on disk.
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Crear el archivo service de systemd
echo "Creando el archivo steamprefill.service..."
cat << EOF | sudo tee /etc/systemd/system/steamprefill.service > /dev/null
[Unit]
Description=SteamPrefill
After=remote-fs.target
Wants=remote-fs.target

[Service]
Type=oneshot
# Sets the job to the lowest priority
Nice=19
User=root
WorkingDirectory=/root/lancache/SteamPrefill
ExecStart=/root/SteamPrefill/SteamPrefill prefill --no-ansi

[Install]
WantedBy=multi-user.target
EOF

# Recargar el daemon de systemd
echo "Recargando el daemon de systemd..."
sudo systemctl daemon-reload

# Habilitar y iniciar el timer
echo "Habilitando y iniciando steamprefill.timer..."
sudo systemctl enable --now steamprefill.timer

# Habilitar el servicio
echo "Habilitando steamprefill.service..."
sudo systemctl enable steamprefill

# Verificar el estado del timer
echo "Verificando el estado de steamprefill.timer..."
sudo systemctl status steamprefill.timer

echo "Configuración de systemd para SteamPrefill completada."

# Checkpoint final
echo "Checkpoint final alcanzado: La instalación y configuración de Lan-Prefill y SteamPrefill se ha completado."
echo "El sistema está listo para su uso."
