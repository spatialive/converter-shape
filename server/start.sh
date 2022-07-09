#!/usr/bin/env sh
gunicorn -k  uvicorn.workers.UvicornWorker --bind 127.0.0.1:8000 -w 4 -t 0 app.server:app