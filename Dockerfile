# 1. Base OS: Ubuntu 20.04
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV SURFBAR="Dingo_Bingo"

# 2. Basic packages
RUN apt-get update && apt-get install -y firefox xvfb wget unzip jq && rm -rf /var/lib/apt/lists/*

# 3. Download the Official PC (Desktop) Addon
RUN mkdir -p /usr/lib/firefox/distribution/extensions/
RUN wget -O /tmp/addon.xpi "https://addons.mozilla.org/firefox/downloads/latest/surf-click/latest.xpi"

# 4. Addon ID Extractor (Bypass Firefox Security)
RUN EXT_ID=$(unzip -p /tmp/addon.xpi manifest.json | jq -r '.browser_specific_settings.gecko.id // .applications.gecko.id') && \
    if [ "$EXT_ID" = "null" ] || [ -z "$EXT_ID" ]; then EXT_ID="addon@ebesucher.com"; fi && \
    cp /tmp/addon.xpi "/usr/lib/firefox/distribution/extensions/${EXT_ID}.xpi"

# 5. 🔥 NEW PROXY & BROWSER CONFIGURATION (Nayi Credentials Ke Sath)
RUN mkdir -p /usr/lib/firefox/browser/defaults/preferences/ && \
    echo 'pref("extensions.autoDisableScopes", 0);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo 'pref("browser.shell.checkDefaultBrowser", false);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo 'pref("media.autoplay.default", 0);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo 'pref("dom.disable_open_during_load", false);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    # Manual Proxy Configuration \
    echo 'pref("network.proxy.type", 1);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo 'pref("network.proxy.http", "154.198.32.71");' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo 'pref("network.proxy.http_port", 8083);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo 'pref("network.proxy.ssl", "154.198.32.71");' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo 'pref("network.proxy.ssl_port", 8083);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo 'pref("network.proxy.share_proxy_settings", true);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    # Headless mode me popup authentication ko automation ke liye bypass karna \
    echo 'pref("signon.autologin.proxy", true);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js

# 6. Global System Proxy Environment Variables (Credentials Injection)
ENV http_proxy="http://zhogyichan.custom38:hello123@154.198.32.71:8083/"
ENV https_proxy="http://zhogyichan.custom38:hello123@154.198.32.71:8083/"

# 7. Startup Script (Silent execution with proxy network environment)
RUN echo '#!/bin/bash\n\
Xvfb :99 -screen 0 1280x720x24 &\n\
export DISPLAY=:99\n\
\n\
export HTTP_PROXY="http://zhogyichan.custom38:hello123@154.198.32.71:8083/"\n\
export HTTPS_PROXY="http://zhogyichan.custom38:hello123@154.198.32.71:8083/"\n\
\n\
firefox --new-instance "https://www.ebesucher.com/surfbar/$SURFBAR" &\n\
tail -f /dev/null\n\
' > /start.sh && chmod +x /start.sh

# 8. Execution
CMD ["/start.sh"]
