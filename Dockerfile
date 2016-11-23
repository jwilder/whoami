FROM microsoft/nanoserver

COPY tmp /
ENV PORT 8000
EXPOSE 8000

CMD ["\\http.exe"]
