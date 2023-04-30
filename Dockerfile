FROM python:3.8-slim-buster
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]