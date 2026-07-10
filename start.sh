#!/bin/bash
set -e

echo "🚀 Starting X-UI + nginx reverse proxy on Railway..."

export NGINX_PORT=${PORT:-3000}

cd /usr/local/x-ui

echo "🔧 Applying panel settings via x-ui CLI..."
./x-ui setting -port 2053 -webBasePath /managepanel/ -username admin -password admin || true

echo "🔧 Building nginx.conf for dynamic port: $NGINX_PORT"
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️ Starting x-ui in background..."
# اجرای x-ui با نادیده گرفتن خطا تا کانتینر کرش نکند
./x-ui > /var/log/x-ui/x-ui.log 2>&1 &

sleep 3

echo "▶️ Starting nginx in foreground on port $NGINX_PORT..."
# تست کردن کانفیگ انجینکس
nginx -t || (echo "❌ Nginx config failed!" && cat /etc/nginx/nginx.conf && exit 1)

exec nginx -g "daemon off;"
