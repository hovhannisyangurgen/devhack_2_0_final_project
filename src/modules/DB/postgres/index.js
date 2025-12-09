const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');
const { postgres: postgresConfig } = require('../../../config/constants');


const db = {};

const sequelize = new Sequelize(postgresConfig.database, postgresConfig.username, postgresConfig.password, {
  ...postgresConfig,
  dialect: 'postgres',
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000,
  },
});

const modelsPath = path.join(__dirname, 'models');

fs
  .readdirSync(modelsPath)
  .filter(file => {
    return (
      file.indexOf('.') !== 0 &&
      file !== path.basename(modelsPath) &&
      file.slice(-3) === '.js'
    );
  })
  .forEach(file => {
    const model = require(path.join(__dirname, 'models', file))(sequelize);
    db[model.name] = model;
  });

Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;
