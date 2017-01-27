//driverlicense.js 
'use strict'

//require loads desired object of node like http, pg, url.......
let http=require('http')
let pg=require("pg")
let urlmod=require("url")
let qs=require("querystring")

//let basehref="/apps/driverlicense/"
let port=3000
let conname="postgres://pguser@localhost/driverlicense"


function sendresponse(html, rs) {
      rs.writeHead(200, {'Content-Type': 'text/html'})
      rs.end(html)
}
function mkhtml(state,age,type){
      let html=""
      html+=`<!DOCTYPE html><html><head><title>driverlicense</title><base href="/apps/driverlicense/"></head><body>`
      html+=`<a href=/apps/driverlicense>HOME1</a>`

      html+=`<h1> You Age is ${age} and you are eligible for ${type} license in ${state} </h1>`
      html+=`</body></html>`

return html 
}

function getlicenseage(urlqueryparams, rs) {
  let client=new pg.Client(conname)
  let db=client.connect(connerr=>{
    if(connerr) {
      console.log("db connection error", connerr)
      rs.writeHead(404, {'Content-Type': 'text/html'})
      rs.end('404 Not found\n')
      return
    }
    let qry=`select name statename, learnerpermitage learner, restrictedpermitage restricted, fulllicenseage fullage from agestate where name='${urlqueryparams.state}'`
   // setTimeout(()=>{
      console.log("now going to call client.query for " + JSON.stringify(urlqueryparams))
    console.log(qry)
      //client.query(qry, (qryerr, rslt)=>{
    client.query(qry, function (qryerr, rslt) {
      if(qryerr) {
        console.log("db query error", qryerr)
        rs.writeHead(404, {'Content-Type': 'text/html'})
        rs.end('404 Not found\n')
        return 
      }
      client.end()
      let row=rslt.rows[0]
      let ageinmonths=parseInt(urlqueryparams.ageyears)*12 + parseInt(urlqueryparams.agemonths)
      console.log("ageinmonths" + ageinmonths)
      let type
      if(ageinmonths<row.learner) {
        type=" No"
      } else if(ageinmonths<row.restricted) {
        type="learner "
      } else if(ageinmonths<row.fullage) {
        type=" restrictedlicense"
      } else {
        type=" fulllicense"
      }
    let html=mkhtml(row.statename,ageinmonths,type)
    sendresponse(html,rs) 
    })
  })
}

//--------------------------------------------

//http.createServer(function(rq, rs) {
http.createServer((rq, rs)=>{
  console.log("request: " + "http method " + rq.method + " url " + rq.url)
  //let postdat=""
  let urlmatch
  if(rq.method === "GET" && /\/dyn\/checkage/.test(rq.url)) {
    let parsedurl=urlmod.parse(rq.url, true)
    //console.log("parsed url object is: " + JSON.stringify(parsedurl))
    let q=parsedurl.query
    console.log("query parameter object is: " + JSON.stringify(q))
getlicenseage(q, rs)
  //rs.end(`<h1>Age check page</h1>`)
  } else {
    console.log("Error: unknown url " + rq.url)
    rs.writeHead(404, {'Content-Type': 'text/html'})
    rs.end('404 Not found\n')
  }
}).listen(port)

console.log('\ndriverlicense running at http://127.0.0.1:' + port)

