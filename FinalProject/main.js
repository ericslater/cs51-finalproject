var scores  = [];
var newgame = [];


var t1Input  = document.getElementById("team1");
var s1Input   = document.getElementById("score1");
var t2Input = document.getElementById("team2");
var s2Input = document.getElementById("score2");
var algorithm = document.getElementById("selector");
var choice = algorithm.options[algorithm.selectedIndex].text;

var messageBox  = document.getElementById("display");

function insert () {

    var sisiList = ["(" + t1Input.value + "," + s1Input.value + ")" + ";" + "(" + t2Input.value + "," + s2Input.value + ")"]
    var newgameList = [t1Input.value + " : " + s1Input.value + " --  " + t2Input.value + " : " + s2Input.value]

    scores.push(sisiList);
    newgame.push(newgameList);

    console.log(scores)

    clearAndShow();
}

function clearAndShow () {
  // Clear our fields
  t1Input.value = "";
  s1Input.value = "";
  t2Input.value = "";
  s2Input.value = "";
  
  // Show our output
  //messageBox.innerHTML = "";
  
  messageBox.innerHTML += "" + newgame + "<br/>";

  newgame = [];
}

function save () {

var stuff = "http://api.nytimes.com/svc/search/v2/articlesearch.json?&fq=headline:(%22mortgage%22+%22unemployment%22+%22foreclosure%22+%22housing%22+%22economic%22+%22bankrupt%22+%22bankruptcy%22+%22economy%22+%22financial+crisis%22)+AND+glocations:(%22" + state + "%22)&page=0&begin_date=20010101&end_date=20110101&sort=oldest&api-key=eafee9bbfe698400bfc25b18cc760590:11:69291451"
var state = "minnesota"

       // $.ajax({
       //   dataType: "json",
       //   url: "exec_file.php",
//
       // success: function (data, status){
       //     
       //   console.log(data)
       //     //console.log(data.response.docs)
//
       //     } });

    $.ajax({
        url : 'exec_file.php', // give complete url here
        type : 'post',
        success : function(data){
            alert('success');
        }
    });
}


var saveToFile = function(object, filename){
    var blob, blobText;
    blobText = [JSON.stringify(object)];
    blob = new Blob(blobText, {
        type: "text/plain;charset=utf-8"
    });
    saveAs(blob, filename);
}
