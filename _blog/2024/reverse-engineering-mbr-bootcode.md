---
title: "Reverse engineering MBR bootcode"
layout: default
date: 2024-09-05
---

In a recent situation I had to deal with a broken MBR record, peeking my curiousity as to what is going on within, and why it had been broken.

First of all the MBR record is a 512 byte long portion of the beginning of a hard drive. In those 512 bytes it contains both code necessary to bootstrap the operating system as well as information about the partition layout of the hard drive itself. Combined this is enough information to hand over control from the BIOS to a partition. It is the partition itself which contains more specific code necessary to bootstrap the installed operating system itself.

To get a grasp on the subject matter here are some recommended readthroughs, at the very least as being pointers on what is going on:

- [FreeBSD: Bootstrapping and Kernel Initialization, The Master Boot Record](https://people.freebsd.org/~rodrigc/doc/en/books/arch-handbook/boot-boot0.html)
- [Wikipedia: Master boot record](https://en.wikipedia.org/wiki/Master_boot_record)
- [X86 Disassembly: The stack](https://en.wikibooks.org/wiki/X86_Disassembly/The_Stack)
- [OSDev: MBR](https://wiki.osdev.org/MBR_(x86))
- [Felix Cloutier: x86 and amd64 instruction reference](https://www.felixcloutier.com/x86/)
- [UToronto: x86 Registers](https://www.eecg.utoronto.ca/~amza/www.mindsec.com/files/x86regs.html)
- [Wikipedia: BIOS interrupt call](https://en.wikipedia.org/wiki/BIOS_interrupt_call)
- [Interrupt Services](https://stanislavs.org/helppc/idx_interrupt.html)

## Testing bootcode
While it is possible to analyse the functioning of the bootcode by analyzing its machine code, doing so is a rather mundane and error prone process. One remarkable thing about opcodes are the number of operations happening under the hood. Quite often the effect of a given opcode will be unclear without reading the actual documentation. This is due to both the number of registers used for the operation itself, as well as the output itself writes back to registers and/or status flags.

For these reasons it is way easier - especially for someone early into the reverse engineering of machine code - just to be able to run the code itself in order to observe its side effects. While one can run such code on an actual machine, the observability tools for doing so suck, and it's recommended to use an actual emulator. Reasonable options for these are QEMU (don't forget to enable full system emulation), or Bochs (my new personal favourite).

**Attaching debuggers**
To peek into the emulated machine, debuggers are quite handy tools. With QEMU one can use GDB to attach an external debugger such as Radare ([see here](/notes/software/testing/qemu-gdb-r2)). Such thing is possible with Bochs as well, though this emulator comes with a built in debugger I prefer to use nowadays.

> For the remainder of this post I'll just assume we're using Bochs

**Starting the system**
Upon startup bochs will halt for us to be able to set breakpoints on relevant positions. The first relevant address is `0x7c00`, which is where the MBR is loaded to by the BIOS. In order to break just before evaluation of the operation at this address we can instruct Bochs to set a breakpoint: `b 0x7c00`. If this breakpoint hits we know control had been transferred to the bootcode contained by the MBR.

---

TBC