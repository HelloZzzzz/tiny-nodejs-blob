const router = require('koa-router')();


router.prefix('/admin');


router.get('/', async function (ctx, next) {

    await ctx.render('admin/login', {error: ''});

});
router.post('/login', async function (ctx, next) {

    const username = ctx.request.body.username;
    const password = ctx.request.body.password;


    if (username === 'admin' && password === 'admin') {
        await ctx.render('admin/backend/index', {path: '', open: ''});
    } else {
        await ctx.render('admin/login', {error: '账号或者密码错误'});
    }
});


module.exports = router;
/*
const express = require('express');
const router = express.Router();

/!* GET home page. *!/
router.get('/', function (req, res, next) {

    res.render('admin/login', {error: ''});

});

router.post('/login', function (req, res, next) {

    const username = req.body.username;
    const password = req.body.password;

    if (username === 'admin' && password === 'admin') {
        res.render('admin/backend/index', {path: '', open: ''});
    } else {

        res.render('admin/login', {error: '账号或者密码错误'});
    }
});

module.exports = router;
*/
