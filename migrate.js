require('dotenv').config();
const { Umzug, SequelizeStorage } = require('umzug');
const { postgres } = require('./src/modules/DB');
const sequelize = postgres.sequelize;
const Sequelize = postgres.Sequelize;


const umzug = new Umzug({
  migrations: { glob: 'src/modules/DB/postgres/migrations/*.js' },
  context: sequelize.getQueryInterface(),
  storage: new SequelizeStorage({ sequelize }),
  logger: console,
})

umzug.up().then(() => {
  console.log('Migrations completed');
}).catch((err) => {
  console.error('Migrations failed', err);
});