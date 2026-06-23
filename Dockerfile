# 1. Base OS: Ubuntu 20.04 (Taaki Firefox bina Snap ke install ho sake)
FROM ubuntu:20.04

# 2. Installation ke waqt koi prompt na aaye isliye noninteractive set kiya
ENV DEBIAN_FRONTEND=noninteractive
ENV SURFBAR="Dingo_Bingo"

# 3. Firefox, Virtual Screen (Xvfb), aur Wget install karna
RUN apt-get update && apt-get install -y \
    firefox \
    xvfb \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 4. Tumhara direct link use karke Addon download aur auto-install karna
RUN mkdir -p /usr/lib/firefox/distribution/extensions/
RUN wget -O /usr/lib/firefox/distribution/extensions/addon@ebesucher.com.xpi https://addons.mozilla.org/android/downloads/file/4828981/surf_click-1.0.1.xpi

# 5. Startup Script banana
RUN echo '#!/bin/bash\n\
echo "Starting Virtual Display (Silent Mode)..."\n\
Xvfb :99 -screen 0 1280x720x24 &\n\
export DISPLAY=:99\n\
\n\
echo "Starting Ubuntu Firefox with eBesucher Addon for User: $SURFBAR"\n\
firefox --new-instance "https://www.ebesucher.com/surfbar/$SURFBAR" &\n\
\n\
# Container ko zinda rakhne ke liye infinite loop\n\
tail -f /dev/null\n\
' > /start.sh && chmod +x /start.sh

# 6. Container start hote hi script run karna
CMD ["/start.sh"]
