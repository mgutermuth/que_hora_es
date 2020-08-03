FROM python:3.8-alpine
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
COPY . .
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]