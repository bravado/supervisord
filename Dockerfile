FROM golang:alpine AS builder

RUN apk add --no-cache --update git

ENV GOBIN=$GOPATH/bin

ADD . /work

WORKDIR /work

RUN go get .

RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-extldflags -static" -o /usr/local/bin/supervisord


FROM alpine

COPY --from=builder /usr/local/bin/supervisord /usr/local/bin/supervisord

RUN apk add bash

RUN chmod u+s /usr/local/bin/supervisord && mkdir /etc/entrypoint.d; echo 'echo hello $(date) $(whoami)' > /etc/entrypoint.d/hello.sh

ENTRYPOINT ["/usr/local/bin/supervisord"]
