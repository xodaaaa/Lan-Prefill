# Lan-Prefill Installer

## Descripción

Lan-Prefill es un script de instalación automatizado diseñado para configurar Lancache y SteamPrefill en sistemas Debian/Ubuntu. Este proyecto facilita la creación de un servidor de caché local para juegos y aplicaciones, optimizando el ancho de banda y mejorando significativamente los tiempos de descarga en entornos de red local.

Originalmente desarrollado para uso personal en LXC Debian (Proxmox), Lan-Prefill también es compatible con otras instalaciones de Debian/Ubuntu, aunque no ha sido exhaustivamente probado en todos los entornos.

## Características

- ✅ Instalación automatizada de Lancache
- 🎮 Configuración de SteamPrefill para precarga de juegos
- ⚙️ Configuración de servicios systemd para ejecución automática
- 🖥️ Interfaz interactiva para configuración personalizada
- 🚀 Optimización del ancho de banda en redes locales
- 🔄 Actualización automática de caché de juegos

## Requisitos

- 🐧 Sistema operativo Debian o Ubuntu
- 🔑 Acceso root o permisos sudo
- 🌐 Conexión a Internet
- 💾 Espacio en disco suficiente para almacenar la caché (recomendado mínimo 1TB)

## Instalación Rápida

Para instalar Lan-Prefill, ejecute los siguientes comandos en su terminal:

```bash
curl -o Lan-prefill-install.sh --location "https://raw.githubusercontent.com/xodaaaa/Lan-Prefill/main/Lan-prefill-install.sh"
chmod +x Lan-prefill-install.sh
./Lan-prefill-install.sh
```

## Uso

Después de la instalación, Lan-Prefill configurará automáticamente Lancache y SteamPrefill. Para gestionar el servicio o realizar precargas manuales, consulte la documentación de Lancache y SteamPrefill.

## Proyectos Originales

Lan-Prefill se basa en los siguientes proyectos:

- [Lancache](https://github.com/lancachenet/docker-compose): Proporciona la infraestructura de caché para múltiples servicios de juegos y aplicaciones.
- [Steam-Lancache-Prefill](https://github.com/tpill90/steam-lancache-prefill): Desarrollado por tpill90, permite la precarga automática de juegos de Steam en la caché.

## Contribuciones

Las contribuciones son bienvenidas. Si encuentra algún problema o tiene sugerencias para mejorar Lan-Prefill, no dude en abrir un issue o enviar un pull request.

## Descargo de Responsabilidad

Lan-Prefill es principalmente una herramienta de automatización para la instalación y configuración de Lancache con SteamPrefill. No es un fork ni una reimplementación de estos proyectos, sino un script que facilita su despliegue y uso.

## Licencia

Este proyecto se distribuye bajo la licencia MIT. Consulte el archivo `LICENSE` para más detalles.

---

Desarrollado con ❤️ por xodaaaa (PansitoDeMichi)
