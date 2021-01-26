const {sequelize} = require('../conf/sequelize_config');
const {Sequelize, Model, DataTypes} = require("sequelize");


class Article extends Model {

}

/**
 * //     id: {type: 'serial', key: true}, //主键
 //     title: String,
 //     content: {type: 'text'},
 //     pubtime: {type: 'date', time: true},
 //     date: String,
 //     brief: {type: 'text'},
 //     tag_id: {type: 'integer'},
 //     hits: {type: 'integer', defaultValue: 0},
 //     bad: {type: 'integer', defaultValue: 0},
 //     good: {type: 'integer', defaultValue: 0},
 //     image: String
 */
Article.init({
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    title: DataTypes.STRING,
    content: {type: 'text'},
    pubtime: {type: 'date', time: true},
    date: DataTypes.STRING,
    brief: {type: 'text'},
    tag_id: {type: 'integer'},
    hits: {type: 'integer', defaultValue: 0},
    bad: {type: 'integer', defaultValue: 0},
    good: {type: 'integer', defaultValue: 0},
    image: DataTypes.STRING

}, {
    sequelize,
    modelName: 'Article', //model名
    tableName: 'article', //表名
    timestamps: false,
    freezeTableName: true
});

module.exports = Article;
