ARG XCUBE_VERSION=0.5.1

FROM quay.io/bcdev/xcube:${XCUBE_VERSION}

ARG XCUBE_VERSION=0.5.2.dev1

USER root

RUN apt-get install -y jq

USER xcube

RUN git clone https://github.com/dcs4cop/xcube
RUN cd  xcube && mamba env update -n xcube && pip install . && cd ..
RUN source activate xcube && mamba install -y -c conda-forge xcube-sh
RUN source activate xcube && mamba install -y -c conda-forge geopandas jdcal
RUN git clone https://github.com/dcs4cop/xcube-cci
RUN cd  xcube-cci && mamba env update -n xcube && pip install . && cd ..
RUN git clone https://github.com/dcs4cop/xcube-cds
RUN cd  xcube-cds && mamba env update -n xcube && pip install . && cd ..

ADD --chown=1000:1000 store_config.json store_config.json
ADD .cdsapirc /home/xcube/.cdsapirc
