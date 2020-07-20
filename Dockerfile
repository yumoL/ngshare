FROM jupyterhub/jupyterhub:1.1.0
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y --no-install-recommends install tzdata

ENV TZ="Europe/Helsinki"
RUN date

COPY . /ngshare/
RUN pip install /ngshare
ARG ID=1017589999
USER $ID:ID
ENTRYPOINT ["python3", "-m", "ngshare"]
