# --- Stage 1: Build ---
FROM ubuntu:22.04 AS builder

# Оновлюємо пакети та встановлюємо залежності
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копіюємо весь проєкт
COPY . .

# Збираємо
RUN mkdir build && cd build && \
    cmake .. && \
    make server

# --- Stage 2: Runtime ---
FROM ubuntu:22.04

WORKDIR /app

# Скопіювати готовий сервер
COPY --from=builder /app/build/server/src/server ./server
COPY --from=builder /app/templates ./templates

EXPOSE 9876

CMD ["./server"]

