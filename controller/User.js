const User = require("../model/User");
/**
 * 根据用户名字获取用户信息
 * @param name
 * @param callback
 * @returns {*}
 */
exports.getUserInfo = async function (name, callback) {

    return await User.findAll({where: {name: name}});

};
