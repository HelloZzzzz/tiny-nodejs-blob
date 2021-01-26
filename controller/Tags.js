const Tags = require("../model/Tags");
const moment = require('moment');

/**
 * 获取标签列表
 * @param
 */
exports.getTagsList = async function () {

    return await Tags.findAll();
};
/**
 * 添加标签
 * @param tagname
 * @param callback
 */
exports.addTag = async function (tagname, callback) {

    let newRecord = {};
    newRecord.tagname = tagname;
    newRecord.created_at = moment().format('YYYY-MM-DD HH:mm:ss');
    return await Tags.create(newRecord);


};
/**
 * 更新标签
 * @param id
 * @param tagname
 * @param callback
 */
exports.updateTag = async function (id, tagname, callback) {

    return await Tags.update(id,tagname);



};