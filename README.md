# The Notebook Toolkit

## Requirements

Allocating resources for your Docker container running Jupyter Notebook with TensorFlow, Julia, R, Scala, and Apache Spark depends on several factors such as the size of datasets you plan to work with, the complexity of computations, and the number of concurrent users (if applicable). Here are some general guidelines for resource allocation:

**CPU**
- **Minimum:** Start with 2 CPU cores (e.g., -c 2 in Docker run command).
- Recommended: Depending on the workload and concurrency, 4 CPU cores or more might be beneficial, especially when running computations in TensorFlow or Apache Spark which can utilize multiple cores effectively.
  
Memory (RAM)

- Minimum: Allocate at least 4GB of RAM (e.g., -m 4G in Docker run command).
- Recommended: Depending on the size of datasets and complexity of computations, 8GB or more of RAM is recommended. TensorFlow and Apache Spark jobs can consume significant amounts of memory, especially when processing large datasets.

Storage

- Minimum: Allocate sufficient storage space for your datasets and notebooks. Ensure you have enough space to store input data, intermediate results, and output files generated during computations.
- Recommended: Depending on your needs, allocate tens to hundreds of gigabytes of storage space. Docker containers typically use the host machine's storage, so ensure your host has adequate storage available.

GPU (Optional)

If your tasks involve intensive computations that can benefit from GPU acceleration (e.g., TensorFlow with GPU support for deep learning tasks), consider using a GPU-enabled Docker image and allocating GPU resources accordingly (--gpus option in Docker run command).

## How to Use

1. Build the custom Docker image:

```sh
docker build -t the-notebook .
```

2. Run the custom Docker image:

Default:
```sh
docker run -d --rm -v $(realpath ~/notebooks):/tf/notebooks -p 8888:8888 the-notebook
```

With reouces allocation

```sh
docker run -d --rm \
  -v $(realpath ~/notebooks):/tf/notebooks \  # Mount notebooks directory
  -p 8888:8888 -p 4040:4040 \                 # Expose ports for Jupyter and Spark UI
  --cpus=4 \                                 # Allocate 4 CPU cores
  --memory=8G \                              # Allocate 8GB of RAM
  the-notebook                               # Docker image name
```


3. Retrieve the Jupyter Notebook token:

```sh
container_id=$(docker ps -lq)
sleep 5
docker logs $container_id | grep -o 'http://127.0.0.1:8888/tree?token=[a-z0-9]\{48\}'
```
