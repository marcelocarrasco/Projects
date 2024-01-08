FROM python:3.10-bullseye

RUN apt-get install curl
RUN apt-get install apt-transport-https
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/msprod.list

RUN apt-get update
ENV ACCEPT_EULA=y DEBIAN_FRONTEND=noninteractive
# RUN apt-get install mssql-tools unixodbc-dev -y

RUN apt-get update && apt-get install -y libaio1 wget unzip unixodbc

WORKDIR /opt/uber-etl

# RUN wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip && \
#     unzip instantclient-basiclite-linuxx64.zip && rm -f instantclient-basiclite-linuxx64.zip && \
#     cd /opt/oracle/instantclient* && rm -f *jdbc* *occi* *mysql* *README *jar uidrvci genezi adrci && \
#     echo /opt/oracle/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf && ldconfig

RUN export INSTALL_ON_LINUX=1; \
 python -m pip install xlwings psutil

RUN python -m pip install --upgrade pip

RUN python -m pip install \
		pandas==2.1.0 \
		pyodbc \
		sqlalchemy==2.0.20 \
		psycopg2 \
		pyarrow==14.0.1

CMD ["python"]