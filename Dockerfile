FROM jupyterhub/jupyterhub:latest
COPY . /ngshare/
RUN pip install /ngshare
ARG ID=1017589999
USER $ID:ID
ENTRYPOINT ["python3", "-m", "ngshare"]
