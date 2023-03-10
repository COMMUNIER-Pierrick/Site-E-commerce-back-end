const database = require('../tools/database');
const paymentDAO = require("./paymentDAO");
const addressDAO = require("./addressDAO");
const Payment = require("../models/Payment");
const User = require("../models/User");
const log = require("../../log/logger");

const errorMessage = "Data access error";

const SQL_INSERT_USER = `INSERT INTO user SET firstname = ?, lastname = ?, password = ?, email = ?, id_payment = ?, id_address = ?`;
const SQL_REMOVE_USER = `DELETE FROM user WHERE id = ?`;
const SQL_UPDATE_PROFILE = `UPDATE user SET firstname = ?, lastname = ?, phone = ?, email = ? WHERE id = ?`;
const SQL_UPDATE_PASSWORD = `UPDATE user SET password = ? WHERE id = ?`;
const SQL_UPDATE_ACTIVE = `UPDATE user SET active = ? WHERE id = ?`;
const SQL_UPDATE_ADMIN = `UPDATE user SET admin = ? WHERE id = ?`;
const SQL_UPDATE_PROFILE_IMG = `UPDATE user SET profile_img = ? WHERE id = ?`;
const SELECT_USER_BY_ID = `SELECT * FROM user WHERE id = ? `;
const SELECT_ALL_USER = `SELECT * FROM user ORDER BY lastname`;

async function updateProfile(User, id){
    let con = null;

    try{
        con = await database.getConnection();
        await con.execute(SQL_UPDATE_PROFILE, [User.firstname, User.lastname, User.phone, User.email, id]);
        return await getById(id);
    }catch (error) {
        log.error("Error userDAO update : " + error);
        throw errorMessage;
    } finally {
        if (con !== null) {
            con.end();
        }
    }
}

async function getById(id){
    let con = null;
    try{
        con = await database.getConnection();
        const [user] = await con.execute(SELECT_USER_BY_ID, [id]);
        delete user.password;
        let payment = await paymentDAO.getById(user[0].id_payment);
        const newPayment = new Payment(payment[0].id, payment[0].card_name, payment[0].card_number, payment[0].card_expired_date);
        const address = await addressDAO.getById(user[0].id_address);
        return new User(user[0].id, user[0].firstname, user[0].lastname, user[0].password, user[0].email, user[0].phone, user[0].active, user[0].admin, user[0].profileImg, newPayment, address);
    }catch (error) {
        log.error("Error userDAO getById : " + error);
        throw errorMessage;
    } finally {
        if (con !== null) {
            con.end();
        }
    }
}

async function getAllUser(){
    let con = null;
    try{
        con = await database.getConnection();
        const [users] = await con.execute(SELECT_ALL_USER);
        let listUsersSender = [];
        for(let i = 0; i < users.length; i++) {
            let newUser = await getById(users[i].id);
            delete newUser.password;

            listUsersSender.push({"User": newUser});
        }
        return listUsersSender;
    }catch (error) {
        log.error("Error userDAO getAllUser : " + error);
        throw errorMessage;
    } finally {
        if (con !== null) {
            con.end();
        }
    }
}

module.exports = {
    updateProfile,
    getById,
    getAllUser,
}