#!/bin/bash
set -e

echo "🦌 Setting up Moose Tutorial Environment..."
echo "============================================"

# Ensure we're in the right directory
cd /workspaces/moose-codespaces-tutorial || cd /workspace || { echo "❌ Could not find workspace directory"; exit 1; }

# Check if Moose is already installed and running
if command -v moose-cli &> /dev/null && curl -s -o /dev/null -w "%{http_code}" http://localhost:4000/health 2>/dev/null | grep -q "200"; then
    echo "✅ Moose is already installed and running!"
    echo "📖 The tutorial files should be open in the editor"
    echo "🌐 Moose API is available at: http://localhost:4000"
    exit 0
fi

# Ensure npm packages are installed
echo "📦 Installing npm dependencies..."
npm install

# Install Moose CLI globally if not already installed
if ! command -v moose-cli &> /dev/null; then
    echo "📦 Installing Moose CLI globally..."
    npm install -g @514labs/moose-cli
fi

# Verify installation
echo "✅ Verifying Moose CLI installation..."
moose-cli --version || { echo "❌ Moose CLI installation failed"; exit 1; }

# Start the dev server
echo "🚀 Starting Moose dev server..."
echo "This will start all infrastructure services (ClickHouse, Redpanda, Redis, Temporal)..."
npm run dev > /tmp/moose-dev.log 2>&1 &
MOOSE_PID=$!

# Wait for services to be ready
echo "⏳ Waiting for services to start (this may take 30-60 seconds)..."
sleep 10

# Check if the process is still running
if ! ps -p $MOOSE_PID > /dev/null; then
    echo "❌ Moose dev server failed to start. Check logs at /tmp/moose-dev.log"
    tail -n 50 /tmp/moose-dev.log
    exit 1
fi

# Wait a bit more for all services to be fully ready
sleep 20

# Check if API is responding
max_retries=30
retry_count=0
while [ $retry_count -lt $max_retries ]; do
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:4000/health | grep -q "200"; then
        echo "✅ Moose API is ready!"
        break
    fi
    echo "⏳ Waiting for Moose API to be ready... ($((retry_count + 1))/$max_retries)"
    sleep 2
    retry_count=$((retry_count + 1))
done

if [ $retry_count -eq $max_retries ]; then
    echo "⚠️  Moose API is taking longer than expected to start."
    echo "You can check the logs with: npm run moose -- logs"
fi

# Try to generate some sample data (don't fail if it doesn't work)
echo "📊 Attempting to generate sample data..."
npm run moose -- workflow run generateRandom 2>/dev/null || echo "ℹ️  Sample data generation will be available once all services are ready."

echo ""
echo "============================================"
echo "✅ Moose Tutorial environment is set up!"
echo "============================================"
echo ""
echo "📖 The tutorial files are open in the editor"
echo "🌐 Moose API will be available at: http://localhost:4000"
echo "📊 To generate test data: npm run tutorial:generate-data"
echo "📋 To view logs: npm run tutorial:logs"
echo ""
echo "Happy coding! 🦌"