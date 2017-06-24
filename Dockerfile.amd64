FROM golang AS build

COPY . /code
WORKDIR /code

RUN CGO_ENABLED=0 go build -a -installsuffix cgo http.go

FROM scratch

COPY --from=build /code/http /http

EXPOSE 8080

CMD ["/http"]
