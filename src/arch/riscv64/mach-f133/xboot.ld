OUTPUT_FORMAT("elf64-littleriscv", "elf64-littleriscv", "elf64-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

STACK_SIZE = 0x100000;

MEMORY
{
	ram  : org = 0x40000000, len = 8M
	dma  : org = 0x40800000, len = 8M
	heap : org = 0x41000000, len = 48M
}

SECTIONS
{
	.text :
	{
		PROVIDE(__image_start = .);
		PROVIDE(__text_start = .);
		PROVIDE(__spl_start = .);
		.obj/arch/riscv64/mach-f133/start.o (.text*)
		.obj/arch/riscv64/lib/memcpy.o (.text*)
		.obj/arch/riscv64/lib/memset.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-smp.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-jtag.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-uart.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-clock.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-dram.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-decompress.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-hash.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-verify.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-spinor.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-spinand.o (.text*)
		.obj/arch/riscv64/mach-f133/sys-copyself.o (.text*)
		. = ALIGN(8);
		PROVIDE(__ddr_bin_start = .);
		KEEP(*(.ddr.bin))
		PROVIDE(__ddr_bin_end = .);
		PROVIDE(__spl_end = .);
		*(.text*)
		*(.init.text)
		*(.exit.text)
		*(.iplt)
		*(.note.gnu.build-id)
		PROVIDE(__text_end = .);
	} > ram
	PROVIDE(__spl_size = __spl_end - __spl_start);

	.initcall ALIGN(8) :
	{
		PROVIDE(__initcall_start = .);
		KEEP(*(.initcall_0.text))
		KEEP(*(.initcall_1.text))
		KEEP(*(.initcall_2.text))
		KEEP(*(.initcall_3.text))
		KEEP(*(.initcall_4.text))
		KEEP(*(.initcall_5.text))
		KEEP(*(.initcall_6.text))
		KEEP(*(.initcall_7.text))
		KEEP(*(.initcall_8.text))
		KEEP(*(.initcall_9.text))
		PROVIDE(__initcall_end = .);
	} > ram

	.exitcall ALIGN(8) :
	{
		PROVIDE(__exitcall_start = .);
		KEEP(*(.exitcall_9.text))
		KEEP(*(.exitcall_8.text))
		KEEP(*(.exitcall_7.text))
		KEEP(*(.exitcall_6.text))
		KEEP(*(.exitcall_5.text))
		KEEP(*(.exitcall_4.text))
		KEEP(*(.exitcall_3.text))
		KEEP(*(.exitcall_2.text))
		KEEP(*(.exitcall_1.text))
		KEEP(*(.exitcall_0.text))
		PROVIDE(__exitcall_end = .);
	} > ram

	.ksymtab ALIGN(16) :
	{
		PROVIDE(__ksymtab_start = .);
		KEEP(*(.ksymtab.text))
		PROVIDE(__ksymtab_end = .);
	} > ram

	.romdisk ALIGN(8) :
	{
		PROVIDE(__romdisk_start = .);
		KEEP(*(.romdisk))
		PROVIDE(__romdisk_end = .);
	} > ram

	.rodata ALIGN(8) :
	{
		PROVIDE(__rodata_start = .);
		*(.rodata*)
		*(.srodata*)
		PROVIDE(__rodata_end = .);
	} > ram

	.data ALIGN(8) :
	{
		PROVIDE(__data_start = .);
		PROVIDE(__global_pointer$ = . + 0x800);
		*(.sdata*)
		*(.data*)
		. = ALIGN(8);
  		PROVIDE(__data_end = .);
		PROVIDE(__image_end = .);
	} > ram

	.bss ALIGN(8) (NOLOAD) :
	{
		PROVIDE(__bss_start = .);
		*(.bss*)
		*(.sbss*)
		*(COMMON)
		. = ALIGN(8);
		PROVIDE(__bss_end = .);
	} > ram

	.stack ALIGN(16) (NOLOAD) :
	{
		PROVIDE(__stack_start = .);
		. += STACK_SIZE;
		. = ALIGN(16);
		PROVIDE(__stack_end = .);
	} > ram

	.dma ALIGN(8) (NOLOAD) :
	{
		PROVIDE(__dma_start = ORIGIN(dma));
		PROVIDE(__dma_end = ORIGIN(dma) + LENGTH(dma));
	} > dma

	.heap ALIGN(8) (NOLOAD) :
	{
		PROVIDE(__heap_start = ORIGIN(heap));
		PROVIDE(__heap_end = ORIGIN(heap) + LENGTH(heap));
	} > heap

	/DISCARD/ : { *(.dynsym) }
	/DISCARD/ : { *(.dynstr*) }
	/DISCARD/ : { *(.dynamic*) }
	/DISCARD/ : { *(.plt*) }
	/DISCARD/ : { *(.interp*) }
	/DISCARD/ : { *(.gnu*) }
}
