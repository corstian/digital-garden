---
title: "QEMU, GDB and Radare2"
layout: default
date: 2024-09-03
toc: false
---

# Using QEMU, GDB and R2 to test a boot image
In order to be able to boot a modern operating system a significant number of steps are necessary to get everything set up in such a way that the operating system can run. This generally starts with some firmware, usually a [BIOS](https://en.wikipedia.org/wiki/BIOS), which then bootstraps the structures necessary to run more complicated code. This code can be retrieved from the first 512 bytes contained on a drive. This first sector might contain a [Master Boot Record](https://en.wikipedia.org/wiki/Master_boot_record) containing further instructions on where to find various partitions, as well as how to initialize the remainder of the system. Various partitions (such as [FAT](https://en.wikipedia.org/wiki/File_Allocation_Table)) may individually contain instructions as well to further bootstrap the system.

The difficulty with all of this is that it is notoriously hard to figure out what is going on at these very early layers in system initialization. Especially without background in electrical engineering it is nearly impossible to gain insight into the inner details of these processes when dealing with actual hardware. If however we have access to an image we can virtualize the process to see what is going on; using QEMU.

## Booting a virtual machine with a hard drive image
QEMU is virtualization software which has wide support for various microprocessor architectures. While this is awesome for running arbitrary workloads, this does not yet gain us any insight into the inner functioning of a system. To get there we can however rely on [GDB; the GNU Debugger](https://en.wikipedia.org/wiki/GNU_Debugger). GDB offers a protocol through which we can remotely debug a system, which is exactly how we can inspect the internal state of the system. While any GDB supporting debugger will suffice, I will specifically focus on the use of Radare2, or R2 for short. This simply for the reason this is the tool I'm most familiar with.

The process to get a machine up and running is as follows:

1. Launch QEMU with the `image.dd` drive image attached, the system frozen on startup (`-S`), serial io redirected (`-serial stdio`) while also allowing a remote debugger to connect (`-gdb tcp::1234` or `-s` in shorthand):
    ```bash
    qemu-system-i386 -drive format=raw,file=image.dd -S -serial stdio -gdb tcp::1234
    ```
2. Launch radare to connect to the virtual machine:
    ```bash
    r2 -D gdb -d gdb://localhost:1234
    ```

From here onwards we are essentially free to move around and work with the code.
