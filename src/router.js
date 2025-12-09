const { Router } = require('express');
const router = Router();
const UserController = require('./controllers/users.controller');

router.get('/', (_, res) => {
  return res.json({ status: 'ok' });
});

router.post('/users', UserController.create);
router.get('/users', UserController.getAll);

module.exports = router;