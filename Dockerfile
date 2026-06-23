# 1. Base OS: Ubuntu 20.04
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV SURFBAR="Dingo_Bingo"

# 2. Basic packages install karna
RUN apt-get update && apt-get install -y firefox xvfb wget && rm -rf /var/lib/apt/lists/*

# 3. Official Desktop eBesucher Addon download karna (Android wala nahi)
RUN mkdir -p /usr/lib/firefox/distribution/extensions/
RUN wget -O /usr/lib/firefox/distribution/extensions/addon@ebesucher.com.xpi https://addons.mozilla.org/firefox/downloads/latest/ebesucher-addon1/latest.xpi

# 4. 🔥 FIREFOX SECURITY BYPASS: Extension ko bina click kiye jabardasti Auto-Enable karna
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
