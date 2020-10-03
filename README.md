# Docker CTF

Use this repo to run CTF challenges created from docker containers. Before
usage, you must have created a file called `commons.sh` in the same directory as
all the other scripts. Use this snippet as a template:

```
REGISTRY=docker.registry.to.use/with/path
SERVICES="challenges separated by spaces"
```

Before running any of these programs, you must login into the docker registry
that you are using:

```
docker login docker.registry.to.use
```
