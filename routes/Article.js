const router = require('koa-router')();
const moment = require('moment');
const tags = require('../controller/Tags');
const article = require('../controller/Article');
//添加文章

router.prefix('/article');

router.get('/add', async function (ctx, next) {

    let tagList = await tags.getTagsList();
    await ctx.render('admin/backend/article/addarticle', {tagList: tagList, path: '/article/add', open: 'article'});


});
//添加文章处理
router.post('/addarticle', async function (ctx, next) {

    const title = ctx.request.body.title;
    const content = ctx.request.body.content;
    const brief = ctx.request.body.brief;
    const tagid = ctx.request.body.tagid;
    const addArticle = await article.addArticle(title, content, brief, tagid).catch(()=>{
        ctx.body = ({status: 1, msg: '添加失败'});
    });
    ctx.body = ({status: 1, msg: '添加成功'});
});
//文章列表
router.get('/articles', async function (ctx, next) {

    //每页显示的记录数
    const pageSizes = 10;
    //当前页
    const pageNow = ctx.query.page ? ctx.query.page : 1;

    //获取总文章数量
    const count = await article.articleCount();
    //获取文章列表
    const articleList = await article.articleList(pageSizes, pageNow);

    for (let i = 0; i < articleList.length; i++) {
        articleList[i].pubtime = moment(articleList[i].pubtime).format('YYYY-MM-DD HH:mm:ss');
        console.log(articleList[i].tag);
    }
    //计算总页数
    const totalPage = parseInt((count + pageSizes - 1) / pageSizes);


    await ctx.render('admin/backend/article/index', {
        articleList: articleList,
        totalCount: count,
        totalPage: totalPage,
        currentPage: pageNow,
        path: '/article/articles',
        open: 'article'
    });
});
//根据文章id查询文章
router.get('/queryById', async function (ctx, next) {

    const id = ctx.query.id;
    let newVar = await article.articleById(id);
    newVar.pubtime = moment(newVar.pubtime).format('YYYY年MM月DD日');
    ctx.body = {article: newVar};

});
//更新文章
router.get('/updateArticle', async function (ctx, next) {

    const id = ctx.query.id;

    const articleById = await article.articleById(id);

    const getTagsList = await tags.getTagsList();
    await ctx.render('admin/backend/article/update', {
        tagList: getTagsList,
        article: articleById,
        path: '/article/articles',
        open: 'article'
    });


});
//更新文章处理
router.post('/updatearticledone', async function (ctx, next) {

    const id = ctx.request.body.id;
    const title = ctx.request.body.title;
    const content = ctx.request.body.content;
    const brief = ctx.request.body.brief;
    const tagid = ctx.request.body.tagid;

    const articleUpdate = await article.articleUpdate(id, title, content, brief, tagid).catch(() => {
        ctx.body = ({status: 0, msg: '更新失败'});
    });
    ctx.body = ({status: 1, msg: '更新成功'});

});

module.exports = router;
