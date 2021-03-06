<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>CS51 Final Project</title>
        <link rel="stylesheet" href="./css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/style.css">
    </head>

    <body>
            
        <div class="navbar navbar-default navbar-fixed-top">
          <div class="container">
            <div class="navbar-header">
              <a href="index.html" class="navbar-brand">OCaml Sports Ranking</a>
              </div>

            <button type = "button" class = "btn btn-success navbar-btn" id = "home">Home</button>
            <button type = "button" class = "btn btn-success navbar-btn" id = "methodology">Methodology</button>
            <button type = "button" class = "btn btn-success navbar-btn" id = "aboutus">About Us</button>
 
            
          </div>
        </div>

          <!-- <h1 class ="title">US States 2003-2012</h1> -->


          <!-- Button trigger modal -->

        <div id="svg-map" class = "vis"></div>
        <div id="svg-parallel"class = "vis"></div>
        <div id="svg-line"class = "vis"></div>
       

<form id = "form">
  <h1>Please enter data</h1>
  <input id="team1" type="text" placeholder="Team 1"/>
  <input id="score1" type="text" placeholder="Team 1's Score"/>
  <input id="team2" type="text" placeholder="Team 2"/>
  <input id="score2" type="text" placeholder="Team 2's Score"/>
  <input type="button" value="Insert" onclick="insert()" />
  
        <hr size="1"/>
        <br>

<h2><b>Data:</b></h2>
<div id="display"></div>

        <hr size="1"/>
        <br>

<div id="methodselect">
        Method:
        <select id="selector">
          <option value="minton">Minton's</option>
          <option value="massey">Massey's</option>
          <option value="collin">Collin's</option>
        </select>
    </div>
</br>
  <input type="button" value="Give Me The Rankings!" onclick="save()" />
</br>

</form>



</div>

        <!-- Stylesheets -->
        <link rel="stylesheet" href="./css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/style.css">

        <!-- Library Javascript Files -->
        <script src="./libs/d3.min.js"></script>
        <script src="./libs/queue.v1.min.js"></script>
        <script src="./libs/topojson.v1.min.js"></script>
        <script src="./libs/jquery-1.11.0.min.js"></script>
        <script src="./libs/FileSaver.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
        <!-- Application Javascript Files -->
        <script src="./js/main.js"></script>

    </body>
</html>
