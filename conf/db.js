const env = process.env.NODE_ENV;  // 环境参数

// 配置
let MYSQL_CONF;
let REDIS_CONF;

if (env === 'dev') {
    // mysql
    MYSQL_CONF = {
        host: '127.0.0.1',
        user: 'root',
        password: '123321',
        database: 'blog',
        port: 3306
    };

    // redis
    REDIS_CONF = {
        port: 6379,
        host: '127.0.0.1'
    }
}
//配置阿里云环境
if (env === 'production') {
    // mysql
    MYSQL_CONF = {
        host: '127.0.0.1',
        user: 'root',
        password: '123321',
        database: 'blog',
        port: 3306
    };

    // redis
    REDIS_CONF = {
        port: 6379,
        host: '127.0.0.1'
    }
}

module.exports = {
    MYSQL_CONF,
    REDIS_CONF
};