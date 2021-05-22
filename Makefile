GOAL="server(8080, wait)"
MAIN_FILE=server.pl
BUILD_DIR=build
SRC_DIR=src

compile:
	swipl --goal=$(GOAL) --stand_alone=true -o $(BUILD_DIR)/server -c $(SRC_DIR)/$(MAIN_FILE)

run-dev:
	swipl -s $(SRC_DIR)/$(MAIN_FILE) -g $(GOAL)

run: compile
	$(BUILD_DIR)/server