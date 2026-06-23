# 1. Base OS: Ubuntu 20.04
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV SURFBAR="Dingo_Bingo"

# 2. Basic packages (jq aur unzip add kiya hai Addon ID nikalne ke liye)
RUN apt-get update && apt-get install -y firefox xvfb wget unzip jq && rm -rf /var/lib/apt/lists/*

# 3. Addon download karna (Tumhara working direct link use kiya hai)
RUN mkdir -p /usr/lib/firefox/distribution/extensions/
RUN wget -O /tmp/addon.xpi "https://addons.mozilla.org/firefox/downloads/file/4828981/surf_click-1.0.1.xpi"

# 🔥 THE MAGIC FIX: Firefox extensions ka file name exact ID se match hona chahiye.
# Ye command addon se automatically uska asli ID nikal kar perfect filename set kar degi.
RUN EXT_ID=$(unzip -p /tmp/addon.xpi manifest.json | jq -r '.browser_specific_settings.gecko.id // .applications.gecko.id') && \
    if [ "$EXT_ID" = "null" ] || [ -z "$EXT_ID" ]; then EXT_ID="addon@ebesucher.com"; fi && \
    cp /tmp/addon.xpi "/usr/lib/firefox/distribution/extensions/${EXT_ID}.xpi"

# 4. 🔥 FIREFOX SECURITY BYPASS: Addon ko background mein auto-enable karna
RUN mkdir -p /usr/lib/firefox/browser/defaults/preferences/
RUN echo 'pref("extensions.autoDisableScopes", 0);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js
RUN echo 'pref("browser.shell.checkDefaultBrowser", false);' >> /usr/lib/firefox/browser/defaults/preferences/syspref.js

# 5. Startup Script
RUN echo '#!/bin/bash\n\
Xvfb :99 -screen 0 1280x720x24 &\n\
export DISPLAY=:99\n\
firefox --new-instance "https://www.ebesucher.com/surfbar/$SURFBAR" &\n\
tail -f /dev/null\n\
' > /start.sh && chmod +x /start.sh

# 6. Execution
CMD ["/start.sh"]
