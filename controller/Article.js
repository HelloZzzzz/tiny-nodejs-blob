const Article = require("../model/Article");
const db = require("../model/Mysql");
const moment = require('moment');
const {Sequelize, Model, DataTypes, QueryTypes} = require("sequelize");
const config = require("../conf/sequelize_config");
//添加文章
exports.addArticle = async function (title, content, brief, tagid) {

    let newRecord = {};
    newRecord.title = title;
    newRecord.content = content;
    newRecord.pubtime = moment().format('YYYY-MM-DD HH:mm:ss');
    newRecord.date = moment().format('YYYY年MM月');
    newRecord.brief = brief;
    newRecord.tag_id = tagid;

    return await Article.create(newRecord);


};
//文章列表
exports.articleList = async function (pageSize, pageNow) {

    // //计算偏移量
    const offset = pageSize * (pageNow - 1);

    return await Article.findAll({
        // attributes: ['id', 'username', 'password'],
        order: [
            ['id', 'DESC']
        ],
        limit: pageSize, // 每页多少条
        offset: offset // 跳过多少条
    });


};
//文章列表
exports.articleSearchList = async function (param) {

    const pageSize = param.pageSize;
    const pageNow = param.pageNow;
    const tagid = param.tagid;
    const date = param.date;
    const key = param.key;
    //计算偏移量
    const offset = pageSize * (pageNow - 1);
    let sql = "SELECT t1.*,t2.logo FROM article as t1 LEFT JOIN tags as t2 on t1.tag_id = t2.id WHERE 1=1 ";
    if (key) {
        sql += " AND t1.title like '%" + key + "%'";
    }
    if (tagid) {
        sql += " AND t1.tag_id = " + tagid;
    }
    if (date) {
        sql += " AND t1.date = '" + date + "'";
    }
    sql += " order by t1.pubtime desc";
    sql += " LIMIT " + offset + "," + pageSize + "";
    return await config.sequelize.query(sql, {
        logging: console.log,

        plain: false,

        raw: false,

        type: QueryTypes.SELECT
    })

};
//文章总记录数
exports.articleCount = async function () {

    return await Article.count();

};
//根据id查询文章
exports.articleById = async function (id) {

    return await Article.findByPk(id);

};
//更新文章
exports.articleUpdate = async function (id, title, content, brief, tagid, callback) {

    let article = await Article.findByPk(id);
    article.title = title;
    article.content = content;
    article.brief = brief;
    article.tagid = tagid;
    return await article.save();

};
//最新文章  按时间排序  5篇文章
exports.articleNew = async function () {

    return await Article.findAll({
        order: [
            // ['id', 'DESC']  // 逆序
            ['pubtime']  //正序
        ]
    })


};
//文章分类数统计
exports.articleTagCount = async function () {

    let sql = "SELECT t2.tagname,t2.id,count(*) as nums FROM article as t1 left join tags as t2 on t1.tag_id = t2.id GROUP BY t1.tag_id;";
    return await config.sequelize.query(sql, {
        logging: console.log,

        plain: false,

        raw: false,

        type: QueryTypes.SELECT
    });

};
//文章存档统计
exports.articleArchives = async function () {




    return await Article.count('date');


};
//更新文章的浏览数数
exports.articleViewsUpdate = async function (id) {


    let article = await Article.findByPk(id);
    article.toJSON();
    article.hits = parseInt(article.hits + 1);
    return await article.save();

};
//更新文章的点赞数
exports.articleGoodUpdate = async function (id, callback) {


    let article = await Article.findByPk(id);
    article.toJSON();
    article.good = parseInt(article.good + 1);
    return await article.save();


};
//更新文章的踩数
exports.articleBadUpdate = async function (id) {

    let article = await Article.findByPk(id);
    article.toJSON();
    article.bad = parseInt(article.bad + 1);
    return await article.save();
};
//获取 上一篇和下一篇
exports.upAndDown = async function (id, callback) {

    //上一篇
    const up = await config.sequelize.query("SELECT * FROM article as t1 WHERE t1.id < '" + id + "' order by id desc limit 0,1 ", {
        logging: console.log,

        plain: false,

        raw: false,

        type: QueryTypes.SELECT
    });
    const down = await config.sequelize.query("SELECT * FROM article as t1 WHERE t1.id > '" + id + "' order by id desc limit 0,1 ", {
        logging: console.log,

        plain: false,

        raw: false,

        type: QueryTypes.SELECT
    });
    return [up, down];

};

