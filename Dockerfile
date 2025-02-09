FROM python:3.11-alpine

# set user and important directories
RUN mkdir -p /home/appuser
RUN addgroup --system appuser && adduser --system appuser -G appuser
ENV HOME=/home/appuser
ENV APP_HOME=/home/appuser/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# install dependencies
RUN apk update && apk add netcat-openbsd
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# copy project
COPY . $APP_HOME
RUN chown -R appuser:appuser $APP_HOME
RUN sed -i 's/\r$//g' $APP_HOME/entrypoint.sh
RUN chmod +x $APP_HOME/entrypoint.sh

EXPOSE 8000
USER appuser

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "gunicorn", "demo.wsgi:application", "--bind", "0.0.0.0:8000" ]