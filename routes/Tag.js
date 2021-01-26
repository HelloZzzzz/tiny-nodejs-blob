const router = require('koa-router')();
const tags = require('../controller/Tags');
const moment = require('moment');

router.prefix('/tag');

//分类列表
router.get('/tags', async (ctx, next) => {

    const getTagsList = await tags.getTagsList();
    for (let i = 0; i < getTagsList.length; i++) {
        getTagsList[i].created_at = moment(getTagsList[i].created_at).format('YYYY-MM-DD HH:mm:ss');
    }
    await ctx.render('admin/backend/tags/index', {tagList: getTagsList, path: '/tag/tags', open: 'tag'});

});
//添加分类界面
router.get('/addtag', async function (ctx, next) {


    await ctx.render('admin/backend/tags/addtag', {path: '/tag/addtag', open: 'tag'});

});
//添加分类处理
router.post('/addtagdeal', async function (ctx, next) {

    const tagname = ctx.request.body.tagname;

    const results = await tags.addTag(tagname);
    await ctx.response.redirect('/tag/tags');

});
//更新分类处理
router.post('/updatetag', async function (ctx, next) {

    const tagname = ctx.request.body.tagname;
    const id = ctx.request.body.id;

    await tags.updateTag(id, tagname).catch(()=>{
        ctx.body = ({status: 0, msg: '更新失败'});
    });
    ctx.body = ({status: 1, msg: '更新成功'});

});
module.exports = router;
