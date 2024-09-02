---
layout: default
title: "FAT Header Parser"
toc: false
---

# FAT Header Parser
This page contains a JS client side tool to parse the header of a FAT partition.

This tool assumes hexadecimal (e.g. `00` to `FF`) values without whitespace. Use [CyberChef](https://gchq.github.io/CyberChef/) to convert your input data into the expected shape. The information shown on this page is inspired by the description about the FAT system as available on [http://elm-chan.org/docs/fat_e.html](http://elm-chan.org/docs/fat_e.html).

<hr />

<span id="inputlength">0 / 512</span>
<textarea id="input" placeholder="Paste your FAT header here" type="text" style="width: 100%; height: 10lh;"></textarea>

<br />

The first part of the FAT header is the same regardless of whether we're dealign with FAT12, FAT16 or FAT32.

<table>
    <thead>
        <th>Field Name</th>
        <th>Offset</th>
        <th>Length</th>
        <th>Contents (string)</th>
        <th>Contents (hex)</th>
        <th>Contents (int)</th>
    </thead>
    <tbody id="table-body">

    </tbody>
</table>

From here onwards the structure of the header diverges based on whether we're dealing with FAT12/FAT16 or with FAT32.

## FAT12 / FAT16
<table>
    <thead>
        <th>Field Name</th>
        <th>Offset</th>
        <th>Length</th>
        <th>Contents (string)</th>
        <th>Contents (hex)</th>
        <th>Contents (int)</th>
    </thead>
    <tbody id="fat16-body">

    </tbody>
</table>

## FAT32
<table>
    <thead>
        <th>Field Name</th>
        <th>Offset</th>
        <th>Length</th>
        <th>Contents (string)</th>
        <th>Contents (hex)</th>
        <th>Contents (int)</th>
    </thead>
    <tbody id="fat32-body">

    </tbody>
</table>


<script type="text/javascript">
    let inputLength = 0
    
    let input = document.getElementById("input")
    let inputLengthIndicator = document.getElementById("inputlength")
    let tableBody = document.getElementById("table-body")
    let fat16Body = document.getElementById("fat16-body")
    let fat32Body = document.getElementById("fat32-body")
    
    // The array here contains the field name and the size of the field
    let genericFatHeaders = [
        ["BS_JmpBoot", 3],
        ["BS_OEMName", 8],
        ["BPB_BytesPerSec", 2],
        ["BPB_SecPerClus", 1],
        ["BPB_RsvdSecCnt", 2],
        ["BPB_NumFATs", 1],
        ["BPB_RootEntCnt", 2],
        ["BPB_TotSec16", 2],
        ["BPB_Media", 1],
        ["BPB_FATSz16", 2],
        ["BPB_SecPerTrk", 2],
        ["BPB_NumHeads", 2],
        ["BPB_HiddSec", 4],
        ["BPB_TotSec32", 4]
    ]

    let fat16SpecificHeaders = [
        ["BS_DrvNum", 1],
        ["BS_Reserved", 1],
        ["BS_BootSig", 1],
        ["BS_VolID", 4],
        ["BS_VolLab", 11],
        ["BS_FilSysType", 8],
        ["BS_BootCode", 448],
        ["BS_Sign", 2]
    ]

    let fat32SpecificHeaders = [
        ["BPB_FATSz32", 4],
        ["BPB_ExtFlags", 2],
        ["BPB_FSVer", 2],
        ["BPB_RootClus", 4],
        ["BPB_FSInfo", 2],
        ["BPB_BkBootSec", 2],
        ["BPB_Reserved", 12],
        ["BS_DrvNum", 1],
        ["BS_Reserved", 1],
        ["BS_BootSig", 1],
        ["BS_VolID", 4],
        ["BS_VolLab", 11],
        ["BS_FilSysType", 8],
        ["BS_BootCode32", 420],
        ["BS_Sign", 2]
    ]

    function hex2a(hexx) {
        var hex = hexx.toString();//force conversion
        var str = '';
        for (var i = 0; i < hex.length; i += 2)
            str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
        return str;
    }

    input.onchange = (event) => {
        inputLengthIndicator.textContent = `${input.value.length/2} / 512`
        
        tableBody.innerHTML = null
        fat16Body.innerHTML = null
        fat32Body.innerHTML = null

        genericFatHeaders.reduce((offset, current) => {
            let row = tableBody.insertRow()
            
            let substr = input.value.substr(offset * 2, current[1] * 2)

            row.insertCell().innerHTML = current[0]
            row.insertCell().innerHTML = offset
            row.insertCell().innerHTML = current[1]
            row.insertCell().innerHTML = `<pre>${hex2a(substr)}</pre>`
            row.insertCell().innerHTML = `<pre>${substr.match(/.{1,2}/g)}</pre>`
            row.insertCell().innerHTML = `<pre>${substr.match(/.{1,2}/g)?.map(q => Number('0x'+q))}</pre>`
            return offset + current[1]
        }, 0)

        fat16SpecificHeaders.reduce((offset, current) => {
            let row = fat16Body.insertRow()
            
            let substr = input.value.substr(offset * 2, current[1] * 2)

            row.insertCell().innerHTML = current[0]
            row.insertCell().innerHTML = offset
            row.insertCell().innerHTML = current[1]
            row.insertCell().innerHTML = `<pre>${hex2a(substr)}</pre>`
            row.insertCell().innerHTML = `<pre>${substr.match(/.{1,2}/g)}</pre>`
            row.insertCell().innerHTML = `<pre>${substr.match(/.{1,2}/g)?.map(q => Number('0x'+q))}</pre>`
            return offset + current[1]
        }, 36)

        fat32SpecificHeaders.reduce((offset, current) => {
            let row = fat32Body.insertRow()
            
            let substr = input.value.substr(offset * 2, current[1] * 2)

            row.insertCell().innerHTML = current[0]
            row.insertCell().innerHTML = offset
            row.insertCell().innerHTML = current[1]
            row.insertCell().innerHTML = `<pre>${hex2a(substr)}</pre>`
            row.insertCell().innerHTML = `<pre>${substr.match(/.{1,2}/g)}</pre>`
            row.insertCell().innerHTML = `<pre>${substr.match(/.{1,2}/g)?.map(q => Number('0x'+q))}</pre>`
            return offset + current[1]
        }, 36)
    }

    input.onchange();
</script>

<style type="text/css">
 table, th, td {
  border: 1px solid black;
  padding: 2px;
}
</style>
