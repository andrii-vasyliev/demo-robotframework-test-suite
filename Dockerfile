FROM python:3.13
COPY ./requirements.txt ./
RUN pythom -m pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade -r ./requirements.txt
ENV ENV_NAME=local
ENV SUITE=Demo_Test_Suite.API.Customers
WORKDIR /robot
CMD robot --name "Demo Test Suite" --pythonpath lib --outputdir log --variable ENV_NAME:$ENV_NAME --suite $SUITE test
