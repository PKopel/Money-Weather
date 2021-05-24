GOAL="server(8080, standalone)"
GOAL_DEV="server(8080, dev)"
MAIN_FILE=server.pl
EXEC_FILE=server.o
BUILD_DIR=build
SRC_DIR=src
IMAGE=swipl-rest-example

dev:
	swipl -s $(SRC_DIR)/$(MAIN_FILE) -g $(GOAL_DEV)

$(BUILD_DIR): 
	mkdir $(BUILD_DIR)

compile: | $(BUILD_DIR)
	swipl --goal=$(GOAL) --stand_alone=true -o $(BUILD_DIR)/$(EXEC_FILE) -c $(SRC_DIR)/$(MAIN_FILE)

run: compile
	$(BUILD_DIR)/$(EXEC_FILE)

docker:
	docker build  -t $(IMAGE) .

docker-run: docker
	docker run -p 8080:8080 $(IMAGE)