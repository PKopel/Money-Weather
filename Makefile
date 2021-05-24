GOAL="server(8080, standalone)"
GOAL_DEV="server(8080, dev)"
MAIN_FILE=server.pl
BUILD_DIR=build
SRC_DIR=src

dev:
	swipl -s $(SRC_DIR)/$(MAIN_FILE) -g $(GOAL_DEV)

compile:
	swipl --goal=$(GOAL) --stand_alone=true -o $(BUILD_DIR)/server -c $(SRC_DIR)/$(MAIN_FILE)

run: compile
	$(BUILD_DIR)/server