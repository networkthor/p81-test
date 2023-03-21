FROM python:3

RUN pip3 install requests

WORKDIR /usr/src/app

COPY ./app-code/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY ./app-code .

ENTRYPOINT [ "python", "./main.py", "-d", "./html/index.html" ]