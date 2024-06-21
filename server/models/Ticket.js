import mongoose from 'mongoose';

const ticketSchema = new mongoose.Schema({
  event: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Event',
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  type: {
    type: String,
    enum: ['VIP', 'General', 'Student'],
    required: true,
  },
  available: {
    type: Boolean,
    default: true,
  },
});

export default mongoose.model('Ticket', ticketSchema);
