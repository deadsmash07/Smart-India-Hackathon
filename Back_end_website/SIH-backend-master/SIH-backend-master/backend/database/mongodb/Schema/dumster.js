const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const DumsterSchema = new mongoose.Schema({
    id:{
        type:String,
        required:true
    },
    name:{
        type:String,
        required:true
    },
    capacity:{
        type:Number,
        required:true
    },
    driver:{
        type:Schema.Types.ObjectId,
        ref:'User'
    },
    status:{
        type:Boolean,
        required:true,
        default:false
    }
});
const Dumster = mongoose.model('Dumster',DumsterSchema);
module.exports = Dumster;