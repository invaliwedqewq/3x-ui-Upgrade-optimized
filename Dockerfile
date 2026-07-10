FROM debian:bookworm-slim

# نصب پیش‌نیازها در یک لایه واحد برای کاهش حجم ایمیج
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite3 \
    nginx \
    gettext-base \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime \
    && rm -rf /var/lib/apt/lists/*

# دانلود، استخراج و پاکسازی فایل X-UI در یک لایه
RUN curl -L https://github.com/sh7CBAC/Heimdall/releases/download/v1.2.0/x-ui-linux-amd64.tar.gz -o /tmp/x-ui.tar.gz \
    && tar -xzf /tmp/x-ui.tar.gz -C /usr/local/ \
    && rm /tmp/x-ui.tar.gz \
    && chmod +x /usr/local/x-ui/x-ui \
    && mkdir -p /etc/x-ui /var/log/x-ui

# کپی فایل‌های پیکربندی
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
COPY sub-view.html /usr/share/nginx/html/view/index.html

RUN chmod +x /start.sh

CMD ["/start.sh"]
