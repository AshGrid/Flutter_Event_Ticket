// controllers/eventController.js
import { log } from 'console';
import Event from '../models/Event.js';
import Ticket from '../models/Ticket.js';
import path from 'path';

export async function createEvent(req, res) {
  console.log(req.body);
    try {
        console.log("android");
        
        const { title, description, date, adress, organizer } = req.body;
        console.log("adresse: ", req.body);
        let image = '';
        const parsedDate = new Date(Date.parse(date));
        console.log(parsedDate);
        if (isNaN(parsedDate)) {
            throw new Error('Invalid date format');
        }
        if (req.file) {
            image = req.file.filename;
            
        }
        else if(req.body.image){
         image=req.body.image;
        }
        console.log("image:",image);
        

        const event = new Event({
            title,
            description,
            date: parsedDate,
            adress,
            organizer,
            image
        });

        await event.save();

        res.status(201).json(event);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
}

export const getAllEvents = async (req, res) => {
  try {
    const events = await Event.find().populate('tickets');
    res.send(events);
  } catch (error) {
    res.status(500).send({ error: 'Failed to fetch events' });
  }
  };
  export const getEventsWithAvailableTickets = async (req, res) => {
    try {
      const events = await Event.find(); // Get all events
  
      const eventsWithAvailableTickets = [];
  
      for (const event of events) {
        const tickets = await Ticket.find({ event: event._id, available: true });
  
        if (tickets.length > 0) {
          eventsWithAvailableTickets.push(event);
        }
      }
  
      res.status(200).json(eventsWithAvailableTickets);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  export const getEventsWithTickets = async (req, res) => {
    try {
      const events = await Event.find({ tickets: { $exists: true } }).populate('tickets');
      res.status(200).json(events);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  export const getEventById = async (req, res) => {
    try {
      const event = await Event.findById(req.body.id).populate('tickets'); // Populate tickets
  
      if (!event) {
        return res.status(404).json({ error: 'Event not found' });
      }
  
      console.log(event.tickets); // Array of ticket documents (after await)
  
      res.status(200).json(event);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };
  export const deleteEvent = async (req, res) => {
    try {
      console.log("deleteID:",req.params.id);
      const deletedEvent = await Event.findByIdAndDelete(req.params.id);
      if (!deletedEvent) {
        return res.status(404).json({ error: 'Event not found' });
      }
      res.status(204).json({message:"deleted"});
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  export const updateEvent = async (req, res) => {
    try {
        const id = req.body.id;
        const parsedDate = new Date(Date.parse(req.body.date));
        let UPimage = '';
        let updateData = {
          title: req.body.title,
          description:req.body.description,
          date: parsedDate,
          adress: req.body.adress,
          organizer: req.body.organizer,
          
      };
        if (req.file) {
            UPimage = req.file.filename;
             updateData = {
              title: req.body.title,
              description:req.body.description,
              date: parsedDate,
              adress: req.body.adress,
              organizer: req.body.organizer,
              image: UPimage
          };
       
        }
        else{
          const updateData = {
            title: req.body.title,
            description:req.body.description,
            date: parsedDate,
            adress: req.body.adress,
            organizer: req.body.organizer,
            
        };
        }
        
      console.log("id",id);
      console.log("data:",updateData);
      const updatedEvent = await Event.findByIdAndUpdate(id, updateData, { new: true });
      if (!updatedEvent) {
        return res.status(404).json({ error: 'Event not found' });
      }
      res.status(200).json(updatedEvent);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };
  

  export const getEventsByQuery = async (req, res) => {
    try {
      const { query } = req.body;
      const events = await Event.find({
        $or: [
          { title: { $regex: query, $options: 'i' } },
          { address: { $regex: query, $options: 'i' } },
          { organizer: { $regex: query, $options: 'i' } }
        ]
      });
      res.status(200).json(events);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };