SRC_DIR = src
BIN_DIR = bin
TARGET = $(BIN_DIR)/word_counter

SRCS = $(wildcard $(SRC_DIR)/*.s)

OBJS = $(patsubst $(SRC_DIR)/%.s, $(BIN_DIR)/%.o, $(SRCS))

AS = as
ASFLAGS = --32
LD = ld
LDFLAGS = -m elf_i386

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(TARGET)

$(BIN_DIR)/%.o: $(SRC_DIR)/%.s | $(BIN_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(BIN_DIR)

.PHONY: all clean