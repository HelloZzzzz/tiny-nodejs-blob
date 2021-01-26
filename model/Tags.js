const {sequelize} = require('../conf/sequelize_config');
const {Sequelize, Model, DataTypes} = require("sequelize");


class Tags extends Model {

}

Tags.init({
    id: {type: 'serial', key: true, primaryKey: true}, //主键
    tagname: {type: 'text', size: 30},
    logo: String,
    created_at: {type: 'date', time: true}

}, {
    sequelize,
    modelName: 'Tags', //model名
    tableName: 'tags', //表名
    timestamps: false,
    freezeTableName: true

});

module.exports = Tags;

/*
const db = require('./Mysql');

const tags = {

    id: {type: 'serial', key: true}, //主键
    tagname: {type: 'text', size: 30},
    logo: String,
    created_at: {type: 'date', time: true}
};
const Tags = db.define('tags', tags);

module.exports = Tags;*/
