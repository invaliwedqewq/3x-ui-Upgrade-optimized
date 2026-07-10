#!/bin/bash
set -e

echo "🚀 Starting X-UI + nginx reverse proxy on Railway..."

# استفاده از پورت داینامیک Railway، و در صورت عدم وجود، استفاده از 3000 برای لوکال
export NGINX_PORT=${PORT:-3000}

cd /usr/local/x-ui

echo "🔧 Applying panel settings via x-ui CLI..."
./x-ui setting -port 2053 -webBasePath /managepanel/ -username admin -password admin || true

echo "🔧 Building nginx.conf for dynamic port: $NGINX_PORT"
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️ Starting x-ui in background..."
./x-ui &
X_UI_PID=$!

sleep 2

echo "▶️ Starting nginx in foreground on port $NGINX_PORT..."
nginx -t
exec nginx -g "daemon off;"
