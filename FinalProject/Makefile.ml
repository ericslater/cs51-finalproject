all: RankingAlgorithms.ml
	corebuild RankingAlgorithms.native

clean:
	rm -rf _build RankingAlgorithms.native
