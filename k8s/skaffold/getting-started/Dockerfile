FROM golang:1.12.0-alpine as builder
COPY main.go .
RUN go build -o /app main.go

FROM alpine
CMD ["./app"]
COPY --from=builder /app .
