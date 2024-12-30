# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o shiori

# Final stage
FROM alpine:3.19
ENV PORT=8080
ENV SHIORI_DIR=/shiori
WORKDIR ${SHIORI_DIR}

COPY --from=builder /app/shiori /usr/bin/shiori
RUN apk add --no-cache ca-certificates tzdata && \
    chmod +x /usr/bin/shiori

EXPOSE ${PORT}
ENTRYPOINT ["/usr/bin/shiori"]
CMD ["server"]
