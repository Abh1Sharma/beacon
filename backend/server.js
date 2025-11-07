const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// In-memory storage (replace with database in production)
let messages = [];

// Helper function to calculate distance between two coordinates (Haversine formula)
function calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371e3; // Earth's radius in meters
    const φ1 = lat1 * Math.PI / 180;
    const φ2 = lat2 * Math.PI / 180;
    const Δφ = (lat2 - lat1) * Math.PI / 180;
    const Δλ = (lon2 - lon1) * Math.PI / 180;

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    return R * c; // Distance in meters
}

// GET /api/messages - Get messages within radius
app.get('/api/messages', (req, res) => {
    const { lat, lng, radius } = req.query;
    
    if (!lat || !lng || !radius) {
        return res.status(400).json({ error: 'Missing required parameters: lat, lng, radius' });
    }

    const userLat = parseFloat(lat);
    const userLng = parseFloat(lng);
    const searchRadius = parseFloat(radius);

    // Filter messages within radius
    const nearbyMessages = messages.filter(msg => {
        const distance = calculateDistance(
            userLat,
            userLng,
            msg.location.latitude,
            msg.location.longitude
        );
        
        // Check if user is within the message's proximity radius
        return distance <= msg.proximityRadius && distance <= searchRadius;
    });

    // Sort by timestamp (newest first)
    nearbyMessages.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

    res.json(nearbyMessages);
});

// POST /api/messages - Create a new message
app.post('/api/messages', (req, res) => {
    const { text, authorId, location, proximityRadius, timestamp } = req.body;

    if (!text || !location || !proximityRadius) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    const message = {
        id: req.body.id || uuidv4(),
        text,
        authorId: authorId || uuidv4(),
        location: {
            latitude: location.latitude,
            longitude: location.longitude
        },
        proximityRadius,
        timestamp: timestamp || new Date().toISOString(),
        replies: []
    };

    messages.push(message);
    res.status(201).json(message);
});

// POST /api/messages/:id/replies - Add a reply to a message
app.post('/api/messages/:id/replies', (req, res) => {
    const { id } = req.params;
    const { text, authorId, timestamp } = req.body;

    if (!text) {
        return res.status(400).json({ error: 'Missing reply text' });
    }

    const message = messages.find(m => m.id === id);
    if (!message) {
        return res.status(404).json({ error: 'Message not found' });
    }

    const reply = {
        id: uuidv4(),
        text,
        authorId: authorId || uuidv4(),
        timestamp: timestamp || new Date().toISOString()
    };

    message.replies.push(reply);
    res.json(message);
});

// Root route
app.get('/', (req, res) => {
    res.json({ 
        message: 'Beacon API Server',
        version: '1.0.0',
        endpoints: {
            health: '/health',
            getMessages: 'GET /api/messages?lat=<lat>&lng=<lng>&radius=<radius>',
            createMessage: 'POST /api/messages',
            addReply: 'POST /api/messages/:id/replies'
        }
    });
});

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', messageCount: messages.length });
});

app.listen(PORT, () => {
    console.log(`🚀 Beacon server running on port ${PORT}`);
    console.log(`📍 API available at http://localhost:${PORT}/api`);
});


