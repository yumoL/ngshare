FROM jupyterhub/jupyterhub:latest
COPY . /ngshare/
RUN pip install /ngshare
ARG ID=10175899999
USER $ID:ID
ENTRYPOINT ["python3", "-m", "ngshare"]
