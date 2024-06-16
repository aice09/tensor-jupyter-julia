# Use the official TensorFlow image with Jupyter as the base image
FROM tensorflow/tensorflow:latest-jupyter

# Install Julia
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.0-linux-x86_64.tar.gz && \
    tar -xvzf julia-1.9.0-linux-x86_64.tar.gz && \
    mv julia-1.9.0 /opt/ && \
    ln -s /opt/julia-1.9.0/bin/julia /usr/local/bin/julia && \
    rm julia-1.9.0-linux-x86_64.tar.gz

# Verify Julia installation
RUN julia -e 'using Pkg; Pkg.add("IJulia")'

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
