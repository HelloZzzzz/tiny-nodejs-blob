const router = require('koa-router')();
/* GET users listing. */

router.prefix('/users');

router.get('/', async function (ctx, next) {
    await ctx.body('暂无页面');
});

module.exports = router;
