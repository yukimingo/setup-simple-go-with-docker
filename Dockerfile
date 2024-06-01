# 使用するGoのバージョンを指定
FROM golang:1.18-alpine AS builder

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係をキャッシュするために先にgo.modとgo.sumをコピー
COPY go.mod go.sum ./
RUN go mod download

# アプリケーションのソースコードをコピー
COPY . .

# アプリケーションをビルド
RUN go build -o main .

# 実行環境として軽量なAlpineイメージを使用
FROM alpine:latest

# 作業ディレクトリを設定
WORKDIR /root/

# ビルドしたアプリケーションをコピー
COPY --from=builder /app/main .

# アプリケーションを実行
CMD ["./main"]

