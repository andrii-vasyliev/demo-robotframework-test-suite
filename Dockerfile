FROM python:3.11
COPY ./requirements.txt ./
RUN pip install --no-cache-dir --upgrade -r ./requirements.txt
ENV ENV_NAME=local
ENV SUITE=Demo_Test_Suite.API.Customers
WORKDIR /robot
CMD robot --name "Demo Test Suite" --pythonpath lib --outputdir log --variable ENV_NAME:$ENV_NAME --suite $SUITE test
