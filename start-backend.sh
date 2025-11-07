#!/bin/bash

echo "🚀 Starting Beacon Backend Server..."
echo ""

cd "$(dirname "$0")/backend"

if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo ""
fi

echo "🌟 Server starting on http://localhost:3000"
echo "📡 API available at http://localhost:3000/api"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

npm start


