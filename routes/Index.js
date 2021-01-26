const router = require('koa-router')();
const moment = require('moment');
const user = require('../controller/User');
const tags = require('../controller/Tags');
const article = require('../controller/Article');

const Sequelize = require('sequelize');
const Op = Sequelize.Op;
let User = require('../model/User');


router.prefix('/');


router.get('/', async function (ctx, next) {
    //文章列表
    //每页显示的记录数
    const pageSizes = 5;
    //当前页
    const pageNow = ctx.query.page ? ctx.query.page : 1;

    let count = await article.articleCount();
    let articleList = await article.articleList(pageSizes, pageNow);
    //时间格式处理
    for (let i = 0; i < articleList.length; i++) {
        articleList[i].pubtime = moment(articleList[i].pubtime).format('YYYY-MM-DD HH:mm:ss');
    }


    //获取最新文章
    let articleNews = await article.articleNew();

    //时间格式处理
    for (let i = 0; i < articleNews.length; i++) {
        articleNews[i].pubtime = moment(articleNews[i].pubtime).format('YYYY-MM-DD');
    }

    let tagsList = await tags.getTagsList();

    //获取存档
    let archives = await article.articleArchives();

    //文章分类文章数
    let tagCounts = await article.articleTagCount();


    //计算总页数
    const totalPage = parseInt((count + pageSizes - 1) / pageSizes);


    await ctx.render('index', {
        articleList: articleList,
        articleNews: articleNews,
        tagList: tagsList,
        archives: archives,
        tagCounts: tagCounts,
        totalCount: count,
        totalPage: totalPage,
        currentPage: pageNow,
        path: 'index',
    });

});
//获取文章具体内容
router.get('/:id.html', async function (ctx, next) {

    const id = ctx.params.id;

    let articleNews = await article.articleNew();
    for (let i = 0; i < articleNews.length; i++) {
        articleNews[i].pubtime = moment(articleNews[i].pubtime).format('YYYY-MM-DD');
    }

    //获取标签
    let getTagsList = await tags.getTagsList();
    //获取存档
    let archives = await article.articleArchives();

    //文章分类文章数
    let tagCounts = await article.articleTagCount();


    //更新文章的点击数
    let result = await article.articleViewsUpdate(id);

    let updowns = await article.upAndDown(id);


    await ctx.render('article', {
        articleNews: articleNews,
        tagList: getTagsList,
        archives: archives,
        tagCounts: tagCounts,
        aid: id,
        updowns: updowns,
        path: 'index'
    });

});
//点赞
router.get('/good', async function (ctx, next) {

    const id = ctx.query.id;
    await article.articleGoodUpdate(id);
    ctx.body = ({status: 1, msg: '点赞成功'});

});
//踩
router.get('/bad', async function (ctx, next) {

    const id = ctx.query.id;
    let result = await article.articleBadUpdate(id);
    ctx.body = ({status: 1, msg: '踩成功'});

});
//文章列表
router.get('/list', async function (ctx, next) {
    //文章列表
    //每页显示的记录数
    const pageSizes = 10;
    //当前页
    const pageNow = ctx.query.page ? ctx.query.page : 1;
    //查询条件
    const tagid = ctx.query.id ? ctx.query.id : 0;
    const key = ctx.query.key ? ctx.query.key : 0;
    const date = ctx.query.date ? ctx.query.date : 0;
    //获取文章列表
    const param = {'pageSize': pageSizes, 'pageNow': pageNow, 'tagid': tagid, 'key': key, 'date': date};

    const articleList = await article.articleSearchList(param);
    for (let i = 0; i < articleList.length; i++) {
        articleList[i].pubtime = moment(articleList[i].pubtime).format('YYYY-MM-DD HH:mm:ss');
    }
    //获取总文章数量
    const count = await article.articleCount();
    //获取最新文章
    const articleNews = await article.articleNew();
    for (let i = 0; i < articleNews.length; i++) {
        articleNews[i].pubtime = moment(articleNews[i].pubtime).format('YYYY-MM-DD');
    }
    //获取标签
    const getTagsList = await tags.getTagsList();

    //获取存档
    const archives = await article.articleArchives();

    //文章分类文章数
    const tagCounts = await article.articleTagCount();

    const totalPage = parseInt((count + pageSizes - 1) / pageSizes);


    await ctx.render('articleList', {
        articleList: articleList,
        articleNews: articleNews,
        tagList: tags,
        archives: archives,
        tagCounts: tagCounts,
        totalCount: count,
        totalPage: totalPage,
        currentPage: pageNow,
        path: 'list'
    });

});
router.get('/about', async function (ctx, next) {

    let articleNews = await article.articleNew();
    for (let i = 0; i < articleNews.length; i++) {
        articleNews[i].pubtime = moment(articleNews[i].pubtime).format('YYYY-MM-DD');
    }
    //获取标签
    let getTagsList = await tags.getTagsList();

    //获取存档
    let archives = await article.articleArchives();

    //文章分类文章数
    let tagCounts = await article.articleTagCount();

    //计算总页数
    await ctx.render('about', {
        articleNews: articleNews,
        tagList: getTagsList,
        archives: archives,
        tagCounts: tagCounts,
        path: 'about'
    });
});
module.exports = router;
