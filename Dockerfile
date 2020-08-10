FROM jupyterhub/jupyterhub:1.1.0

COPY . /ngshare/
RUN pip install /ngshare
RUN pip install pandas

ARG ID=1017589999
USER $ID:ID
ENTRYPOINT ["python3", "-m", "ngshare"]
