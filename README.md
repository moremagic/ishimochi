# Setup

- Add `config/hosts.yml`

example

```yml
glass_fish:
  - host1
  - host2
  - host3
tomcat:
  - host4
  - host5
```

- Bundle install

```sh
bundle install --path vendor/bundle
```

- rackup

```sh
bundle exec rackup
```

