const db = require('../modules/DB');


class UsersController {
  async create(req, res) {
    const { email } = req.body;
    const user = await db.User.create({ email });
    return res.json(user);
  }

  async getAll(req, res) {
    const users = await db.User.findAll();
    return res.json(users);
  }
}

module.exports = new UsersController();