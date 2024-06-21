import { Schema, model } from 'mongoose';

const eventSchema = new Schema({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: false
  },
  date: {
    type: Date,
    required: false
  },
  adress: { // Corrected spelling
    type: String,
    required: true
  },
  organizer: {
    type: String,
    required: true
  },
  image: {
    type: String,
    required: false
  },
  tickets: {
    type: [{ type: Schema.Types.ObjectId, ref: 'Ticket' }], // Array of ObjectIds referencing tickets
    default: [] // Initialize an empty array
  }
},
{
  timestamps: true
});

const eventModel = model('Event', eventSchema);

export default eventModel;
