###################################
# Makefile for Java Projects      #
# ------------------------------- #
# Usage:						
# 
#   make        - Compile the project
#   make setup  - Create src and classes directories if they don't exist
#   make run    - Run the main class
#   make clean  - Clean compiled files
# ------------------------------- #



# Directories
SRC_DIR := src
BIN_DIR := classes

# Find all .java files in src/ (recursively)
SOURCES := $(shell find $(SRC_DIR) -name "*.java")
CLASSES := $(SOURCES:$(SRC_DIR)/%.java=$(BIN_DIR)/%.class)

# Main class (change according to your project)
MAIN_CLASS := Main

# Rule to create the BIN_DIR folder if it doesn't exist
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Default rule: compile everything
all: $(BIN_DIR) $(CLASSES)

# make a src directory if it doesn't exist
setup: $(BIN_DIR)
	mkdir -p $(SRC_DIR)
	# Create any other necessary directories here
	touch $(SRC_DIR)/$(MAIN_CLASS).java


# Compilation
$(BIN_DIR)/%.class: $(SRC_DIR)/%.java
	mkdir -p $(dir $@)
	javac -d $(BIN_DIR) -cp $(SRC_DIR) $(SOURCES)

# Run the program
run: all
	java -cp $(BIN_DIR) $(MAIN_CLASS)

# Cleaning
clean:
	rm -rf $(BIN_DIR)
