all: UserInput.ml 
	corebuild -lib str UserInput.native


clean:
	rm -rf _build UserInput.native
