const {sequelize}  = require('../conf/sequelize_config');
const {Sequelize, Model, DataTypes} = require("sequelize");
// const user = {
//
//     id: {type: 'serial', key: true}, //主键
//     username: String,
//     password: String,
//     created_at: {type: 'integer', defaultValue: 0},
//     updated_at: {type: 'integer', defaultValue: 0}
// };
// const User = db.define('user', user);

class User extends Model {

}

User.init({
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    username: {
        type: Sequelize.INTEGER,
    },
    password: {
        type: Sequelize.INTEGER,
    }

}, {
    sequelize,
    modelName: 'User', //model名
    tableName: 'user', //表名
    timestamps: false,
    freezeTableName: true
});

module.exports = User;