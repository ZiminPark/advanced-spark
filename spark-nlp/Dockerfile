FROM ubuntu:18.04


# Set the ARGsa
ARG spark_version="2.4.7"
ARG hadoop_version="2.7"
ARG openjdk_version="8"
ARG python_version="3.7.10"

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}" 

USER root


# Java and dependencies installation
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
    sudo \
    apt-utils \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    git \
    libffi-dev \
    liblzma-dev \
    locales \
    g++ \
    libpcre3-dev \
    tar \
    bash \
    rsync \
    gcc \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libpng-dev \
    libzmq3-dev \
    unzip \
    pkg-config \
    software-properties-common \
    "openjdk-${openjdk_version}-jre-headless" \
    ca-certificates-java \
    graphviz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Add a user
ENV USER zimin
ENV HOME /home/"${USER}"
RUN useradd -rm -d "${HOME}" -s /bin/bash -g root -G sudo -u 1001 "${USER}"
USER $USER


# Python installation using pyenv
WORKDIR ${HOME}
ENV PYENV_ROOT ${HOME}/.pyenv 
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN git clone https://github.com/pyenv/pyenv.git .pyenv && \
    pyenv install "${python_version}" && \
    pyenv global "${python_version}"

ENV PYSPARK_PYTHON=python \
    PYSPARK_DRIVER_PYTHON=python

RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir pandas jupyterlab pyspark=="${APACHE_SPARK_VERSION}" spark-nlp spylon-kernel==0.4.* pyarrow==2.0.* && \
    python -m spylon_kernel install --sys-prefix && \
    # pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc


# Spark installation
USER root
WORKDIR /tmp
## Using the preferred mirror to download Spark
## hadolint ignore=SC2046
RUN wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

WORKDIR /usr/local

## Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin

RUN ln -s "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark && \
    # Add a link in the before_notebook hook in order to source automatically PYTHONPATH
    mkdir -p /usr/local/bin/before-notebook.d && \
    ln -s "${SPARK_HOME}/sbin/spark-config.sh" /usr/local/bin/before-notebook.d/spark-config.sh

## Fix Spark installation for Java 11 and Apache Arrow library
## see: https://github.com/apache/spark/pull/27356, https://spark.apache.org/docs/latest/#downloading
RUN cp -p "$SPARK_HOME/conf/spark-defaults.conf.template" "$SPARK_HOME/conf/spark-defaults.conf" && \
    echo 'spark.driver.extraJavaOptions="-Dio.netty.tryReflectionSetAccessible=true"' >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo 'spark.executor.extraJavaOptions="-Dio.netty.tryReflectionSetAccessible=true"' >> $SPARK_HOME/conf/spark-defaults.conf

WORKDIR "${HOME}" 
USER "${USER}"

EXPOSE 8888 4040 4041 4042 9083
CMD ["cd", "/home/zimin/app"]
CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token=''", "--NotebookApp.password=''"]

