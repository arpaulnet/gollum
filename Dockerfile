##############################
FROM alpine:3 as base
##############################
RUN apk add --no-cache \
    ruby \
    tzdata

##############################
FROM base as build
##############################
RUN apk add --no-cache \
    build-base \
    cmake \
    git \
    openssl-dev \
    ruby-dev \
    zlib-dev
RUN gem install \
    etc \
    gollum \
    rdoc \
    webrick \
    commonmarker \
    asciidoctor \
    creole \
    wikicloth \
    org-ruby \
    RedCloth \
  && rm -rf /usr/lib/ruby/gems/*/cache/*

RUN mkdir -p /wiki \
  && cd /wiki \
  && git init \
  && gollum --versions

##############################  
FROM base as gollum
##############################
COPY --from=arpaulnet/s6-overlay-stage:2.0 / /
COPY --from=build /wiki              /wiki
COPY --from=build /wiki              /default/wiki
COPY --from=build /usr/bin/gollum    /usr/bin/gollum
COPY --from=build /usr/lib/ruby/gems /usr/lib/ruby/gems
COPY              ./rootfs           /
WORKDIR /wiki
VOLUME /wiki
EXPOSE 4567/tcp
ENV TZ=UTC \
    PUID=666 \
    PGID=666 \
    HOME=/wiki
ENTRYPOINT ["/init", "with-contenv", "s6-setuidgid", "app"]
CMD ["gollum"]
