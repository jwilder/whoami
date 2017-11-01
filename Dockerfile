FROM golang AS build

ARG arch=amd64

COPY . /code
WORKDIR /code

ENV GOARM 6

RUN CGO_ENABLED=0 GOOS=linux GOARCH=$arch go build -a -installsuffix cgo http.go

FROM scratch

COPY --from=build /code/http /http

EXPOSE 8080

CMD ["/http"]
