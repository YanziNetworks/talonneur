# Talonneur

Talonneur will watch URL for changes and trigger webhooks whenever necessary.

This is work in progress

## Example

The following resource example watches for the source description of the
postgres official Docker image at github and will trigger an image build at the
Docker hub whenever the description has changed, i.e. probably a new version has
been made available.


```conf
URL=https://raw.githubusercontent.com/docker-library/official-images/master/library/postgres
HOOK=https://hub.docker.com/api/build/v1/source/xxxx-yyy-zzz7rrr/trigger/c629a183-14d5-4200-aab3-b444d8b93d25/call/
REQUEST=POST
```
