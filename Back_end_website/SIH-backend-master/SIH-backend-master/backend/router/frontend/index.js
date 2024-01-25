const express=require('express');
const jwt=require('jsonwebtoken');
const User=require('../../database/mongodb/Schema/users');
const Query=require('../../database/mongodb/Schema/queries');
const Dumper=require('../../database/mongodb/Schema/dumster');
const Shovel=require('../../database/mongodb/Schema/shovel');
const Annoucement = require('../../database/mongodb/Schema/annoucements');
const frontend=express.Router();
frontend.post('/authenticate', (req, res) => {
    User.findOne({ email: req.body.email })
        .then(user => {
            if (!user) {
                res.status(404).json({ success: false, message: 'Authentication failed. User not found.' });
            } else {
                user.comparePassword(req.body.password, (err, isMatch) => {
                    if (err) throw err;
                    if (isMatch&&user.type==='admin') {
                        user.generateAutho()
                            .then(user => {
                                res.json({ success: true, message: 'Authentication succeeded.', autho: user.autho,name:user.name });
                            })
                            .catch(err => {
                                throw err;
                            });
                    } else {
                        res.status(401).json({ success: false, message: 'Authentication failed. Wrong password.' });
                    }
                });
            }
        })
        .catch(err => {
            throw err;
        });
});
frontend.post('/register',async(req,res)=>{
    try{
        var newUser=new User({
            name:req.body.name,
            email:req.body.email,
            password:req.body.password,
            type:req.body.type
        });
        await newUser.generateAutho();
        await newUser.save();
        res.json({success:true,message:'Register successed',autho:newUser.autho,type:newUser.type});
    }
    catch(err){
        res.status(401).json({success:false,message:'Register failed'+err});
    }
});
frontend.use((req,res,next)=>{
    var autho=req.headers['Authorization'] || req.headers['authorization'];
    if(autho){
        autho=autho.split(' ')[1];
        jwt.verify(autho,process.env.SECRET,(err,decoded)=>{
            if(err){
                return res.status(403).json({success:false,message:'Failed to authenticate token.'});
            }else{
                req.decoded=decoded;
                next();
            }
        });
    }else{
        return res.status(403).send({
            success:false,
            message:'No token provided.'
        });
    }
})

frontend.get('/drivers',async(req,res)=>{
    try{
        await User.find({type:'driver',status:true}).then(users=>{
            res.json({success:true,message:'Get drivers succeeded',users:users});
        }).catch(err=>{
            throw err;
        });
    }
    catch(err){
        res.status(401).json({success:false,message:'Get drivers failed'+err});
    }
})
frontend.get('/users', (req, res) => {
    try {
        const type = req.query.type;
        const name = req.query.name;

        let query = { type: { $in: ['driver', 'worker'] } };

        if (type) {
            query.type = type;
        }

        if (name) {
            query.name = { $regex: new RegExp(name), $options: 'i' };
        }

        User.find(query, 'name type History total').then(users => {
            res.json({ success: true, message: 'Get users succeeded', users: users });
        }).catch(err => {
            throw err;
        });
    } catch (err) {
        res.status(401).json({ success: false, message: 'Get users failed' + err });
    }
});

frontend.delete('/queries/:id',(req,res)=>{
    try{
        const id=req.params.id;
        Query.findByIdAndDelete(id).then(query=>{
            res.json({success:true,message:'Delete queries succeeded',query:query});
        }).catch(err=>{
            throw err;
        });
    }
    catch(err){
        res.status(401).json({success:false,message:'Delete queries failed'+err});
    }
})
frontend.put('/queries/:id',(req,res)=>{
    try{
        const id=req.params.id;
        Query.findByIdAndUpdate(id,{$set:{status:true}}).then(query=>{
            res.json({success:true,message:'Update queries succeeded',query:query});
        }).catch(err=>{
            throw err;
        });
    }
    catch(err){
        res.status(401).json({success:false,message:'Update queries failed'+err});
    }
});
frontend.post('/queries',(req,res)=>{
    try{
        const newQuery=new Query({
            user:req.body.user,
            description:req.body.description
        });
        newQuery.save().then(query=>{
            User.findByIdAndUpdate(req.body.user,{$push:{queries:query._id}}).then(user=>{
                res.json({success:true,message:'Post queries succeeded',query:query});
            }).catch(err=>{
                throw err;
            });
        }).catch(err=>{
            throw err;
        });
    }
    catch(err){
        res.status(401).json({success:false,message:'Post queries failed'+err});
    }
})

frontend.get('/queries',(req,res)=>{
    try{
        const status=false;
        const queries=Query.find({status:status}).populate('user','name email type _id').then(queries=>{
            res.json({success:true,message:'Get queries succeeded',queries:queries});
        }).catch(err=>{
            throw err;
        });
    }
    catch(err){
        res.status(401).json({success:false,message:'Get queries failed'+err});
    }
})
frontend.get('/dumpers_shovels_summary',async (req,res)=>{
    try{
        const trueDumper=await Dumper.countDocuments({status:true});
        const falseDumper=await Dumper.countDocuments({status:false});
        const trueShovel=await Shovel.countDocuments({status:true});
        const falseShovel=await Shovel.countDocuments({status:false});
        res.json({success:true,message:'Get dumpers_shovels_summary succeeded',trueDumper:trueDumper,falseDumper:falseDumper,trueShovel:trueShovel,falseShovel:falseShovel});

    }
    catch(err){
        res.status(401).json({success:false,message:'Get dumpers_shovels_summary failed'+err});
    }
});

//ANNOUCEMENTS
frontend.get('/annoucements',(req,res)=>{
    try{
        const annoucements=Annoucement.find({}).sort({createdAt:-1}).then(annoucements=>{
            res.json({success:true,message:'Get annoucements succeeded',annoucements:annoucements});
        }).catch(err=>{
            throw err;
        });
    }
    catch(err){
        res.status(401).json({success:false,message:'Get annoucements failed'+err});
    }
})
frontend.post('/annoucements',(req,res)=>{
    try{
        const newAnnoucement=new Annoucement({
            content:req.body.content
        });
        newAnnoucement.save().then(annoucement=>{
            res.json({success:true,message:'Post annoucements succeeded',annoucement:annoucement});
        }).catch(err=>{
            throw err;
        });
    }
    catch(err){
        res.status(401).json({success:false,message:'Post annoucements failed'+err});
    }
})




//Dumpster and Shovel
frontend.get('/dumpsters_shovels',async (req,res)=>{
    try{
        const dumper=await Dumper.find({}).populate('driver','name')
        const shovel=await Shovel.find({}).populate('worker','name')
        res.status(200).json({success:true,message:'Get dumpsters_shovels succeeded',dumper:dumper,shovel:shovel});
    }
    catch(err){
        res.status(401).json({success:false,message:'Get dumpsters failed'+err});
    }
});
// frontend.get('/dumpster_shovel_location',async (req,res)=>{
//     try{
//         const dumper=await Dumper.find({status:true}).select('latitude longitude');
//         const shovel=await Shovel.find({status:true}).select('latitude longitude');
//         res.status(200).json({success:true,message:'Get dumpster_shovel_location succeeded',dumper:dumper,shovel:shovel});
//     }
//     catch(err){
//         res.status(401).json({success:false,message:'Get dumpster_shovel_location failed'+err});
//     }
// });
frontend.post('/dumpster',async (req,res)=>{
    try{
        const newDumper=new Dumper({
            id:req.body.id,
            name:req.body.name,
            capacity:req.body.capacity
        });
        await newDumper.save();
        res.status(200).json({success:true,message:'Post dumpster succeeded',dumper:newDumper});
    }
    catch(err){
        res.status(401).json({success:false,message:'Post dumpster failed'+err});
    }
});
frontend.post('/shovel',async (req,res)=>{
    try{
        const newShovel=new Shovel({
            id:req.body.id,
            name:req.body.name,
            size:req.body.size
        });
        await newShovel.save();
        res.status(200).json({success:true,message:'Post shovel succeeded',shovel:newShovel});
    }
    catch(err){
        res.status(401).json({success:false,message:'Post shovel failed'+err});
    }
});
module.exports=frontend;