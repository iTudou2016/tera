//Bitcointalk ANN crawler

var express = require('express');

var app = express();
var fs = require('fs');
var redis = require('redis');
var redisClient = redis.createClient();
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.set('views','.');
app.set('view engine', 'pug');

//GET method route
app.get('/tera/*', function(req, res) {
//showTeraRigs(req,res);
if (req.params[0]=="tera" || req.params[0]=="corey" || req.params[0]=="weiwu") {
showTeraRigs(req,res);
} else {
res.send("Contact Admin to create new account.");
}
});

app.use(express.static('data'));

// POST method route
app.post('/*', function (req, res) {
if (req.params[0]=="tera" || req.params[0]=="corey" || req.params[0]=="weiwu") {
updateTeraRigs(req,res);
} else {
res.send("Contact Admin to create new account.");
}
});

var server = app.listen(9999, function () {
var host = server.address().address;
var port = server.address().port;
  console.log('Data listening at http://%s:%s', host, port);
});

setInterval(pruneRigInfo, 24*60*60*1000);
pruneRigInfo();

function showTeraRigs(req,res){
  var rigInfo = [];
  redisClient.zrange(req.params[0], 0, -1,"withscores", async function(err, result) {
    if (err) throw err;                                                                                                                
    console.log("Page refresh: " + req.params[0] + ": " + result.length/2);                                                            
    let batch = await redisClient.batch();                                                                                             
    for(i=0; i<result.length; i+=2) {                                                                                                  
      batch.hget(result[i], 'cpuload');                                                                                                
    }                                                                                                                                  
    batch.exec(function(err, reply) {                                                                                                  
      for(i=0; i<reply.length; i++) {                                                                                                  
        rigInfo.push({"rigIP": result[i*2],                                                                                            
          "cpuload": reply[i],                                                                                                         
          "lastSeen": result[i*2+1],                                                                                                   
        });                                                                                                                            
      }                                                                                                                                
      res.render("tera", {rigInfo: rigInfo});                                                                                          
    });                                                                                                                                
  });                                                                                                                                  
}                                                                                                                                      
                                                                                                                                       
async function updateTeraRigs(req, res) {                                                                                              
  var cpuload = req.body.cpuload;                                                                                                      
  var rigIP = req.headers['x-forwarded-for'] ||                                                                                        
      req.connection.remoteAddress ||                                                                                                  
      req.socket.remoteAddress ||                                                                                                      
      req.connection.socket.remoteAddress;                                                                                             
  var lastSeen = Date.now();                                                                                                           
  await redisClient.zadd(req.params[0],lastSeen, rigIP);                                                                               
  await redisClient.hset(rigIP, "cpuload", cpuload);                                                                                   
  console.log(rigIP + "//" + cpuload + "//" +lastSeen);                                                                                
  res.end();                                                                                                                           
}                                                                                                                                      
async function pruneRigInfo() {                                                                                                        
  var lastSeen=Date.now();                                                                                                             
  var userList=["tera", "corey", "weiwu"];                                                                                             
  console.log("pruneRigInfo started:....");                                                                                            
  for(let k=0; k<userList.length; k++){                                                                                                
    await redisClient.zrangebyscore(userList[k], "-inf", lastSeen-86400000, async function(err, expRigIP) {                            
      let batch = await redisClient.batch();                                                                                           
      for(let i=0; i<expRigIP.length; i++) {                                                                                           
        batch.hdel(expRigIP[i], 'cpuload');                                                                                            
      }                                                                                                                                
      batch.exec(function(err, reply) {                                                                                                
        redisClient.zremrangebyscore(userList[k], "-inf", lastSeen-86400000);                                                          
      });                                                                                                                              
    });                                                                                                                                
    console.log(userList[k] + ": done.");                                                                                              
  }                                                                                                                                    
  console.log("pruneRigInfo completed.");                                                                                              
}     
