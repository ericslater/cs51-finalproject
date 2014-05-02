<?
        $matrix = $_GET["scores"];
 	$algorithm = $_GET["algo"];
	echo "asdf";
        if ($algorithm = "Minton's"){
	echo shell_exec("./RankingAlgorithms.native Mintons $matrix"); 
        echo $matrix
	} elseif ($algorithm = "Massey's") {
	  //echo exec("./RankingAlgorithms.native Massey $matrix");
	  echo $matrix;
	}
	else {
	  //echo exec("./RankingAlgorithms.native Colley $matrix"); 
	  echo "asdf";
	  echo $matrix';
	}

?>

