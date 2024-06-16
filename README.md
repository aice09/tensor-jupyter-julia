# How to use

1. Build the custom Docker image:

```sh
docker build -t tensorflow-julia .
```

2. Run the custom Docker image:

```sh
docker run -d --rm -v $(realpath ~/notebooks):/tf/notebooks -p 8888:8888 tensorflow-julia
```

3. Retrieve the Jupyter Notebook token:

```sh
container_id=$(docker ps -lq)
sleep 5
docker logs $container_id | grep -o 'http://127.0.0.1:8888/tree?token=[a-z0-9]\{48\}'
```
