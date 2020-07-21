FROM jupyterhub/jupyterhub:1.1.0

COPY . /ngshare/
RUN pip install /ngshare

ARG ID=1017589999
USER $ID:ID
ENTRYPOINT ["python3", "-m", "ngshare"]
