#!/bin/bash

echo "========================================"
echo "Starting HedgeDoc 1.x"
echo "========================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed!"
    echo "Please install Docker first: https://docs.docker.com/engine/install/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null; then
    echo "ERROR: Docker Compose is not installed!"
    echo "Please install Docker Compose first"
    exit 1
fi

# Start Docker daemon if not running
if ! docker ps &> /dev/null; then
    echo "[1/3] Starting Docker daemon..."
    sudo systemctl start docker
    sleep 3
else
    echo "[1/3] Docker daemon is already running"
fi

echo "[2/3] Starting HedgeDoc containers..."
sudo docker compose up -d

echo "[3/3] Waiting for services to start..."
sleep 10

echo ""
echo "========================================"
echo "HedgeDoc is ready!"
echo "========================================"
echo ""
echo "Web Interface: http://localhost:3000"
echo ""

# Show container status
sudo docker compose ps

echo ""
echo "To stop HedgeDoc, run: ./stop-hedgedoc.sh"
