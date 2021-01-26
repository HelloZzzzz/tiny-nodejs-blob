const {MYSQL_CONF} = require('./db');
const Sequelize = require('sequelize');
const Op = Sequelize.Op;


const db = {};
//配置操作符别称
const operatorsAliases = {
    $eq: Op.eq,
    $ne: Op.ne,
    $gte: Op.gte,
    $gt: Op.gt,
    $lte: Op.lte,
    $lt: Op.lt,
    $not: Op.not,
    $in: Op.in,
    $notIn: Op.notIn,
    $is: Op.is,
    $like: Op.like,
    $notLike: Op.notLike,
    $iLike: Op.iLike,
    $notILike: Op.notILike,
    $regexp: Op.regexp,
    $notRegexp: Op.notRegexp,
    $iRegexp: Op.iRegexp,
    $notIRegexp: Op.notIRegexp,
    $between: Op.between,
    $notBetween: Op.notBetween,
    $overlap: Op.overlap,
    $contains: Op.contains,
    $contained: Op.contained,
    $adjacent: Op.adjacent,
    $strictLeft: Op.strictLeft,
    $strictRight: Op.strictRight,
    $noExtendRight: Op.noExtendRight,
    $noExtendLeft: Op.noExtendLeft,
    $and: Op.and,
    $or: Op.or,
    $any: Op.any,
    $all: Op.all,
    $values: Op.values,
    $col: Op.col
};

//创建sequelize
const sequelize = new Sequelize(MYSQL_CONF.database, MYSQL_CONF.user, MYSQL_CONF.password, {
    host: MYSQL_CONF.host,
    dialect: 'mysql',
    port: MYSQL_CONF.port,
    pool: {
        max: 3,
        min: 1,
        idle: 8000
    },
    operatorsAliases
});
db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;