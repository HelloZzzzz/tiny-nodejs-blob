const Koa = require('koa');
const app = new Koa();
const views = require('koa-views');
const json = require('koa-json');
const onerror = require('koa-onerror');
const bodyparser = require('koa-bodyparser');
const logger = require('koa-logger');

const index = require('./routes/Index');
const users = require('./routes/Users');
const admin = require('./routes/Admin');
const article = require('./routes/Article');
const tag = require('./routes/Tag');
const staticCache = require('koa-static-cache');

const path = require('path');

// error handler
onerror(app);

// middlewares
app.use(bodyparser({
    enableTypes: ['json', 'form', 'text']
}));
app.use(json());
app.use(logger());
app.use(require('koa-static')(__dirname + '/public'));


//将ejs替换成html
// app.use(views(__dirname + '/views', {
//     extension: 'ejs'
// }));


app.use(views(__dirname + '/views', {
    map: {html: 'ejs'}
}));


app.use(staticCache(path.join(__dirname, './public'), {dynamic: true}, {
    maxAge: 365 * 24 * 60 * 60
}));
app.use(staticCache(path.join(__dirname, './views'), { dynamic: true }, {
    maxAge: 365 * 24 * 60 * 60
}));


// logger
app.use(async (ctx, next) => {
    const start = new Date();
    await next();
    const ms = new Date() - start;
    console.log(`${ctx.method} ${ctx.url} - ${ms}ms`)
});

// routes
app.use(index.routes());
app.use(users.routes());
app.use(admin.routes());
app.use(article.routes());
app.use(tag.routes());

// error-handling
app.on('error', (err, ctx) => {
    console.error('server error', err, ctx)
});

module.exports = app;
