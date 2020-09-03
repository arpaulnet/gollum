# Gollum
[Gollum](https://github.com/gollum/gollum) is a simple wiki system built on top of Git.

## Tags
In addition to `latest`, this repository uses semantic versioned tags:
* full version (ex: `5.1.1`)
* major & minor version (ex: `5.1`)
* major version (ex: `5`)

## Architectures
This repository uses multi-platform images via Docker manifests.  You do not need to use a platform-specific tag; Docker will automatically choose the appropriate architecture.  Currently, the supported architectures are:
* `x86`/`386`
* `x86_64`/`amd64`
* `arm`/`armv6`
* `armhf`/`armv7`
* `arm64`
* `ppc64le`

## Usage

`docker run -d -v "${PWD}/wiki:/wiki" -p "4567:4567" -e "PUID=$(id -u)" -e "PGID=$(id -g)" arpaulnet/gollum`

`docker-compose.yml`
```yaml
#...
services:
  gollum:
    image: arpaulnet/gollum
    environment:
      PGID: 1000
      PUID: 1000
      TZ: America/Denver
    restart: unless-stopped
```

### Gollum Options
[Gollum](https://github.com/gollum/gollum) has a number of [command line options](https://github.com/gollum/gollum#configuration) that can be passed at startup to configure it.  To use these commands, simply configure the docker command.  For example, if you wanted to set the HTTP base path to `.../my-custom-basepath`, you could run the container like so:

`docker run ... arpaulnet/gollum gollum --base-path /my-custom-basepath`

### Environment Variables
| Environment Variable | Default | Description                             |
|----------------------|---------|-----------------------------------------|
| `PGID`               | `666`   | Process Group ID (use with bind mounts) |
| `PUID`               | `666`   | Process User ID (use with bind mounts)  |
| `TZ`                 | `UTC`   | TZ Database Name (ex: `America/Denver`) |

## Markups
[Gollum](https://github.com/gollum/gollum) supports a number of [Markups](https://github.com/gollum/gollum#markups). A default installation of Gollum supports `Markdown` and `RDoc`.  This repository also bundles:
* `AsciiDoc`
* `Creole`
* `MediaWiki`
* `Org`
* `Textile`

See Gollum's [Markups](https://github.com/gollum/gollum#markups) documentation for more information.

This repository also uses `commonmarker` for markdwon rendering rather than the default `kramdown`.
