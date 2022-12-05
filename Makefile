# Config
# =============

TOOLCHAIN=riscv64-unknown-elf-

AS=$(TOOLCHAIN)as
LD=$(TOOLCHAIN)ld
LINKER_SCRIPT=virt.ld
SOURCES=$(wildcard *.S)
OUTDIR=build
OBJ=$(OUTDIR)/sufferisc.o
BIN=$(OUTDIR)/sufferisc

QEMU=qemu-system-riscv64
HARTS=1

GDB=$(TOOLCHAIN)gdb
OBJDUMP=$(TOOLCHAIN)objdump

# Setup
# =============

setup:
	@mkdir -p $(OUTDIR)

# Build
# =============

as:
	@$(AS) $(SOURCES) -o $(OBJ)

link:
	@$(LD) -T$(LINKER_SCRIPT) $(OBJ) -o $(BIN)

build: as link

# Debug
# =============

qemu:
	@$(QEMU) -machine virt -cpu rv64 -smp $(HARTS) -s -S  -nographic -bios none -kernel $(BIN)

gdb:
	@$(GDB) $(BIN) -ex "target remote :1234"

dump:
	@$(OBJDUMP) -D $(BIN)
