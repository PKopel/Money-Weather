GOAL="server(8080, wait)"
MAIN_FILE=server.pl
BUILD_DIR=build

compile:
	swipl --goal=$(GOAL) --stand_alone=true -o $(BUILD_DIR)/server -c $(MAIN_FILE)

run-dev:
	swipl -s $(MAIN_FILE) -g $(GOAL)

run: compile
	$(BUILD_DIR)/server