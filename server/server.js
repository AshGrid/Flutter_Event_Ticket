// app.js

import eventRoutes from './routes/eventsRoute.js';
import ticketRoutes from './routes/ticketsRoute.js';
import { join } from 'path';

import express from 'express';
import json from 'express';
import bodyParser from 'body-parser';
import dbConnect from './dbConnect.js';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

const app = express();
app.use(cors());
app.use(json());
app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ extended: true, limit: '10mb' }));
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);



// Serve static files from the uploads directory
app.use('/uploads', express.static(join(__dirname, 'uploads')));

// Routes
app.use('/api', eventRoutes);
app.use('/api',ticketRoutes);

const port = process.env.PORT || 8000;
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
