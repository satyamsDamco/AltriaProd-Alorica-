var OPEN_DAYS=["Mon","Tue","Wed","Thu","Fri"],OPEN_MINUTE=9*60,CLOSE_MINUTE=19*60;
function easternNow(d){
  var parts=new Intl.DateTimeFormat("en-US",{timeZone:"America/New_York",weekday:"short",hour:"numeric",minute:"numeric",hour12:false}).formatToParts(d);
  var out={};for(var i=0;i<parts.length;i++)out[parts[i].type]=parts[i].value;return out;
}
function isOpen(d){var t=easternNow(d);
  if(OPEN_DAYS.indexOf(t.weekday)===-1)return false;
  var m=(parseInt(t.hour,10)%24)*60+parseInt(t.minute,10);
  return m>=OPEN_MINUTE&&m<CLOSE_MINUTE;}
var S=[["Wed 2:00 PM EDT","2026-08-05T18:00:00Z",true],
["Wed 8:30 PM EDT","2026-08-06T00:30:00Z",false],
["Mon 8:59 AM just shut","2026-08-03T12:59:00Z",false],
["Mon 9:00 AM opens","2026-08-03T13:00:00Z",true],
["Fri 6:59 PM last min","2026-08-07T22:59:00Z",true],
["Fri 7:00 PM closes","2026-08-07T23:00:00Z",false],
["Sat 11:00 AM weekend","2026-08-08T15:00:00Z",false],
["Wed 2:00 PM EST winter","2027-01-13T19:00:00Z",true],
["Wed 8:00 AM EST winter","2027-01-13T13:00:00Z",false]];
var fail=0;
S.forEach(function(s){var d=new Date(s[1]);var p=easternNow(d);var a=isOpen(d);
 var ok=a===s[2]; if(!ok)fail++;
 console.log((ok?"PASS":"FAIL")+"  "+s[0].padEnd(24)+" parts="+JSON.stringify(p).padEnd(46)+" -> "+(a?"online":"offline"));});
console.log("\nmidnight hour probe:", JSON.stringify(easternNow(new Date("2026-08-06T04:00:00Z"))));
console.log(fail===0?"\nALL PASS":"\n"+fail+" FAILED");
