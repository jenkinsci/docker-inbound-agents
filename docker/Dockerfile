FROM jenkins/inbound-agent:alpine

USER root

# Alpine seems to come with libcurl baked in, which is prone to mismatching
# with newer versions of curl. The solution is to upgrade libcurl.
RUN apk add --no-cache -u libcurl curl

# Install Docker client, Docker compose, and buildx
RUN curl -s https://download.docker.com/linux/static/stable/`uname -m`/ | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | sort -t . -k 1,1n -k 2,2n -k 3,3n | tail -n 1 > /tmp/docker_version \
    && curl -fsSL https://download.docker.com/linux/static/stable/`uname -m`/docker-`cat /tmp/docker_version`.tgz | tar --strip-components=1 -xz -C /usr/local/bin docker/docker \
    && rm /tmp/docker_version
RUN curl -s -I https://github.com/docker/compose/releases/latest | awk -F '/' '/^location/ {print substr($NF, 1, length($NF)-1)}'  > /tmp/compose_version \
    && mkdir -p /usr/libexec/docker/cli-plugins/ \
    && curl -fsSL https://github.com/docker/compose/releases/download/`cat /tmp/compose_version`/docker-compose-`uname -s`-`uname -m` > /usr/libexec/docker/cli-plugins/docker-compose \
    && chmod +x /usr/libexec/docker/cli-plugins/docker-compose \
    && rm /tmp/compose_version
## buildx is released as amd64, and uname calls it x86_64
RUN uname -m > /tmp/arch \
    && sed -i 's/x86_64/amd64/g' /tmp/arch \
    && curl -s -I https://github.com/docker/buildx/releases/latest | awk -F '/' '/^location/ {print substr($NF, 1, length($NF)-1)}' > /tmp/buildx_version \
    && curl -fsSL https://github.com/docker/buildx/releases/download/`cat /tmp/buildx_version`/buildx-`cat /tmp/buildx_version`.`uname -s`-`cat /tmp/arch` > /usr/libexec/docker/cli-plugins/docker-buildx \
    && chmod +x /usr/libexec/docker/cli-plugins/docker-buildx \
    && docker buildx install \
    && rm /tmp/arch /tmp/buildx_version

RUN touch /debug-flag
USER jenkins
