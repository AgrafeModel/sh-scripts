# Define the compiler and compiler flags
CC = gcc
CFLAGS = -Wall -Wextra -O2
LDFLAGS =

# Define directories
SRC_DIR = .
BUILD_DIR = build

# Find all .c files in the source directory
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
# Define the object files corresponding to the source files
OBJ_FILES = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRC_FILES))

# Define the target executable
TARGET = main

# Default target to build everything
all: $(TARGET)

# Rule to build the target executable
$(TARGET): $(OBJ_FILES)
	@mkdir -p $(BUILD_DIR)
	$(CC) $(LDFLAGS) -o $@ $^

# Rule to build object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

# Clean up build artifacts
clean:
	rm -f $(TARGET) $(BUILD_DIR)/*.o

.PHONY: all clean
