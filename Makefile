
run-dev:
	swipl --goal="server(8080)" -s server.pl

build:
	swipl --goal="server(8080)" --stand_alone=true -o build/server -O -c server.pl