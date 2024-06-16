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

# Install Python packages
RUN pip install matplotlib kaggle pandas

# Install R and R essentials
RUN apt-get update && \
    apt-get install -y r-base && \
    R -e "install.packages('IRkernel', repos='http://cran.us.r-project.org')" && \
    R -e "IRkernel::installspec(user = FALSE)"

# Install Scala (Apache Toree kernel)
RUN apt-get update && \
    apt-get install -y scala && \
    apt-get install -y wget && \
    wget https://archive.apache.org/dist/incubator/toree/0.5.0-incubating/toree-pip/toree-0.5.0.tar.gz && \
    pip install toree-0.5.0.tar.gz && \
    jupyter toree install --spark_home=/usr/local/spark --interpreters=Scala

# Install Apache Spark
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk-headless && \
    wget -q https://archive.apache.org/dist/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz && \
    tar -xzf spark-3.2.0-bin-hadoop3.2.tgz -C /usr/local && \
    rm spark-3.2.0-bin-hadoop3.2.tgz

# Set environment variables for Spark and Hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.12-src.zip
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=$SPARK_HOME

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose Spark UI port
EXPOSE 4040

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip='*'", "--port=8888", "--no-browser", "--allow-root"]
