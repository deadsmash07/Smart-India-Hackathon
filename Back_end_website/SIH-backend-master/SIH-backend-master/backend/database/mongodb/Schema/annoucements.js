const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const AnnoucementSchema = new mongoose.Schema({
    content:{
        type:String,
        required:true
    },
    createdAt:{
        type:Date,
        default:Date.now
    },
});
const Annoucement = mongoose.model('Annoucement',AnnoucementSchema);
module.exports = Annoucement;