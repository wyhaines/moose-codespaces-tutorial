#!/bin/bash

# Quick check script to see if Moose environment is set up

echo "🔍 Checking Moose Tutorial Environment..."
echo "========================================="

# Check if moose-cli is installed
if command -v moose-cli &> /dev/null; then
    echo "✅ Moose CLI is installed: $(moose-cli --version)"
else
    echo "❌ Moose CLI is NOT installed"
    echo "   Run: npm install -g @514labs/moose-cli"
fi

# Check if npm dependencies are installed
if [ -d "node_modules" ]; then
    echo "✅ NPM dependencies are installed"
else
    echo "❌ NPM dependencies are NOT installed"
    echo "   Run: npm install"
fi

# Check if Moose services are running
if curl -s -o /dev/null -w "%{http_code}" http://localhost:4000/health 2>/dev/null | grep -q "200"; then
    echo "✅ Moose API is running at http://localhost:4000"
else
    echo "❌ Moose API is NOT running"
    echo "   Run: npm run dev"
fi

# Check Docker
if docker ps &> /dev/null; then
    echo "✅ Docker is running"
    MOOSE_CONTAINERS=$(docker ps --format "table {{.Names}}" | grep -E "(redpanda|clickhouse|redis|temporal)" | wc -l)
    if [ $MOOSE_CONTAINERS -gt 0 ]; then
        echo "✅ Found $MOOSE_CONTAINERS Moose-related containers running"
    else
        echo "⚠️  No Moose infrastructure containers found"
    fi
else
    echo "❌ Docker is not accessible"
fi

echo ""
echo "========================================="
echo "To start the tutorial environment, run:"
echo "  bash .devcontainer/startup.sh"
echo "========================================="