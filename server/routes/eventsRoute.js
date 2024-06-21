// routes/eventRoutes.js
import { Router } from 'express';
const router = Router();
import { createEvent,getAllEvents,getEventById,deleteEvent,updateEvent,getEventsByQuery,getEventsWithTickets,getEventsWithAvailableTickets  } from '../controllers/eventsController.js';
import  upload  from '../middlewares/multerConfig.js';

router.post('/events', upload.single('image'), createEvent);
router.get('/events', getAllEvents);
router.get('/events/ticket', getEventsWithTickets);
router.get('/events/tickets', getEventsWithAvailableTickets);
router.post('/event', getEventById);
router.delete('/delEvent/:id', deleteEvent);
router.put('/events',upload.single('image'),updateEvent);
router.post('/events/search', getEventsByQuery);
export default router;
