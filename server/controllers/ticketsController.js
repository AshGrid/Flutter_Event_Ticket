import Ticket from '../models/Ticket.js';
import Event from '../models/Event.js';
// Create a new ticket
export const createTicket = async (req, res) => {
 console.log("body: ",req.body);
  try {
    const ticket = new Ticket(req.body);
    await ticket.save();

    // Update the event to include this ticket
    await Event.findByIdAndUpdate(ticket.event, { $push: { tickets: ticket._id } });

    res.status(201).send(ticket);
  } catch (error) {
    res.status(500).send({ error: 'Failed to create ticket' });
  }
};

// Get all tickets
export const getAllTickets = async (req, res) => {
  try {
    const tickets = await Ticket.find();
    res.status(200).json(tickets);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getAllAvailableTickets = async (req, res) => {
  try {
    const tickets = await Ticket.find({ available: true }).populate('event'); // Filter by available
    res.status(200).json(tickets);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get ticket by ID
export const getTicketById = async (req, res) => {
  try {
    const ticket = await Ticket.findById(req.params.id).populate('event');
    if (!ticket) {
      return res.status(404).json({ error: 'Ticket not found' });
    }
    res.status(200).json(ticket);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update ticket
export const updateTicket = async (req, res) => {
  try {
    console.log(req.body);
    const { id, ...updateData } = req.body;
    const updatedTicket = await Ticket.findByIdAndUpdate(id, updateData, { new: true }).populate('event');
    if (!updatedTicket) {
      return res.status(404).json({ error: 'Ticket not found' });
    }
    res.status(200).json(updatedTicket);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const updateAvaliability = async (req, res) => {
  try {
    console.log(req.body); // Log the entire request body
    const { id } = req.body;
    console.log('Ticket ID:', id); // Log the ticket ID

    const updatedTicket = await Ticket.findByIdAndUpdate(id, { available: false }, { new: true }).populate('event'); // Example update
    if (!updatedTicket) {
      return res.status(404).json({ error: 'Ticket not found' });
    }
    res.status(200).json(updatedTicket);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete ticket
export const deleteTicket = async (req, res) => {
  try {
    const { id } = req.body;
    const deletedTicket = await Ticket.findByIdAndDelete(id);
    if (!deletedTicket) {
      return res.status(404).json({ error: 'Ticket not found' });
    }
    res.status(204).end();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
export const getTicketsByEventId = async (req, res) => {
  try {
    const eventId = req.body.eventId; // Assuming event ID is in request body
console.log(eventId);
    //const event = await Event.findById(eventId).populate('tickets');
    const ticket = await Ticket.find({event:eventId});

    
    // Extract event details
   

   
    // Extract ticket details
  

    res.status(200).json({ 
     
      tickets: ticket 
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

