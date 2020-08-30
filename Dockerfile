FROM alpine:3 as base
RUN apk add --no-cache ruby

FROM base as build
RUN apk add --no-cache \
    build-base \
    cmake \
    git \
    openssl-dev \
    python3 \
    py3-pip \
    ruby-dev \
    zlib-dev

RUN pip3 install dumb-init

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
  
FROM base as gollum
COPY --from=build /wiki              /wiki
COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build /usr/bin/gollum    /usr/bin/gollum
COPY --from=build /usr/lib/ruby/gems /usr/lib/ruby/gems
WORKDIR /wiki
VOLUME /wiki
EXPOSE 4567/tcp
ENTRYPOINT ["dumb-init"]
CMD ["gollum", "--host", "0.0.0.0", "--port", "4567", "--base-path", "/wiki", "/wiki"]
