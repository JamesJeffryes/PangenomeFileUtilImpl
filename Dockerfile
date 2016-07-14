FROM kbase/kbase:sdkbase.latest
MAINTAINER KBase Developer
# -----------------------------------------

# Make sure SSL certs are properly installed
RUN apt-get install python-dev libffi-dev libssl-dev \
    && pip install pyopenssl ndg-httpsclient pyasn1 \
    && pip install requests --upgrade \
    && pip install 'requests[security]' --upgrade

# Install KBase Transform Scripts + dependencies
# Note: may not always be safe to copy things to /kb/deployment/lib
# Note: if you change install path of transform, update the deploy.cfg configuration appropriately
RUN mkdir -p /kb/module && cd /kb/module && git clone https://github.com/kbase/transform && \
    cd transform && git checkout d02762c && \
    cp -ar lib/Bio/KBase/Transform /kb/deployment/lib/Bio/KBase

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod 777 /kb/module

WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
