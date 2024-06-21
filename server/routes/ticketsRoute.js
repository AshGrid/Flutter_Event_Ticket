import { Router } from 'express';
import {
  createTicket,
  getAllTickets,
  getTicketById,
  updateTicket,
  deleteTicket,
  getTicketsByEventId,
  updateAvaliability,
  getAllAvailableTickets
} from '../controllers/ticketsController.js';

const router = Router();

router.post('/tickets', createTicket);
router.post('/ticketsByEvent', getTicketsByEventId);
router.get('/tickets', getAllTickets);
router.get('/tickets/av', getAllAvailableTickets);
router.get('/tickets/:id', getTicketById);
router.put('/tickets', updateTicket);
router.put('/ticket/buy', updateAvaliability);
router.delete('/tickets', deleteTicket);

export default router;
