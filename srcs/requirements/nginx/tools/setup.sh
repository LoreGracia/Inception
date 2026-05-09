#!/bin/sh

# Aquí podrías añadir lógica extra si fuera necesario, 
# como comprobar que los certificados existen.

# Lanzamos NGINX reemplazando el proceso del script
exec nginx -g "daemon off;"