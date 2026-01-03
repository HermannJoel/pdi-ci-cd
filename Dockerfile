FROM debian:bullseye as java_builder

RUN apt-get update && apt-get install -y openjdk-11-jdk wget tar gzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.17%2B8/OpenJDK11U-jdk_x64_linux_hotspot_11.0.17_8.tar.gz -O /tmp/openjdk-11.tar.gz && \
    mkdir -p /usr/lib/jvm && \
    tar -xzf /tmp/openjdk-11.tar.gz -C /usr/lib/jvm && \
    mv /usr/lib/jvm/jdk-11.0.17+8 /usr/lib/jvm/java-11-openjdk-11.0.17 && \
    rm /tmp/openjdk-11.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.17
ENV PATH="$JAVA_HOME/bin:$PATH"
ENV JAVA_VERSION=11.0.17

RUN java -version

FROM apache/airflow:latest

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY pipelines/dags/ /opt/airflow/dags/

COPY entrypoint.sh /entrypoint.sh

USER root

RUN chmod +x /entrypoint.sh

COPY --from=java_builder /usr/lib/jvm/java-11-openjdk-11.0.17 /usr/lib/jvm/java-11-openjdk-11.0.17


ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.17
ENV PATH="$JAVA_HOME/bin:$PATH"

USER airflow

ENTRYPOINT ["/entrypoint.sh"]


FROM postgres:13

COPY /src/init-warehouse.sql /docker-entrypoint-initdb.d/
ENV LANG en_US.utf8