<head>
 
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
 
 
  <script>
 
  $(document).ready(function(){
    $("#test_form").submit(function()
    {
      //pass login details
      $.post("exec_file.php",{ 
        a1:"asf",
        b1:"asdf",
        rand:Math.random() } ,
        function(data)
          {
            console.log(data);
            document.write(data);
          });
      return false; //not to post the form 
    });
  });
  </script>
 
</head>
 
 
<body>
 
  <form method = "post" action="" id="test_form">
    click this to run ocaml
    <input name ="Submit" type="submit" id="submit" value="submit" />
  </form>
 
</body>