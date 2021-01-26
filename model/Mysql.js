const {MYSQL_CONF} = require("../conf/db");
const orm = require("orm");
//拼接 连接mysql的 uri
const uri = "mysql://" + MYSQL_CONF.user + ":" + MYSQL_CONF.password + "@" + MYSQL_CONF.host + "/" + MYSQL_CONF.database;
//连接数据库
const conn = orm.connect(uri, function (err, db) {

    if (err) {
        return console.error('Connection error: ' + err);
    }

});
module.exports = conn;






