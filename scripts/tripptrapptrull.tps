// This Pine Script™ code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © pikebay Dec 2023

//@version=5
indicator("TrippTrappTrull", overlay = true)
ht1=input.timeframe("15", "ht1", inline="ht1"),lblHt1=input.bool(false, "Lblht1", inline="ht1")
ht2=input.timeframe("60", "ht2", inline="ht2"),lblHt2=input.bool(false, "Lblht2", inline="ht2")
ht3=input.timeframe("240", "ht3", inline="ht3"),lblHt3=input.bool(true, "Lblht3", inline="ht3")
ht4=input.timeframe("D", "ht4", inline="ht4"),lblHt4=input.bool(true, "Lblht4", inline="ht4")
ht5=input.timeframe("W", "ht5", inline="ht5"),lblHt5=input.bool(true, "Lblht5", inline="ht5")


openHt1=request.security(syminfo.tickerid, ht1, ta.valuewhen(barstate.isconfirmed, open, 0))
highHt1=request.security(syminfo.tickerid,ht1, ta.valuewhen(barstate.isconfirmed, high, 0))
lowHt1=request.security(syminfo.tickerid,ht1, ta.valuewhen(barstate.isconfirmed, low, 0))
closeHt1=request.security(syminfo.tickerid,ht1, ta.valuewhen(barstate.isconfirmed, close, 0))

openHt2=request.security(syminfo.tickerid,ht2, ta.valuewhen(barstate.isconfirmed, open, 0))
highHt2=request.security(syminfo.tickerid,ht2, high)
lowHt2=request.security(syminfo.tickerid,ht2, low)
closeHt2=request.security(syminfo.tickerid,ht2, ta.valuewhen(barstate.isconfirmed, close, 0))

openHt3=request.security(syminfo.tickerid,ht3, ta.valuewhen(barstate.isconfirmed, open, 0))
highHt3=request.security(syminfo.tickerid,ht3, high)
lowHt3=request.security(syminfo.tickerid,ht3, low)
closeHt3=request.security(syminfo.tickerid,ht3, ta.valuewhen(barstate.isconfirmed, close, 0))

openHt4=request.security(syminfo.tickerid,ht4, ta.valuewhen(barstate.isconfirmed, open, 0))
highHt4=request.security(syminfo.tickerid,ht4, high)
lowHt4=request.security(syminfo.tickerid,ht4, low)
closeHt4=request.security(syminfo.tickerid,ht4, ta.valuewhen(barstate.isconfirmed, close, 0))

openHt5=request.security(syminfo.tickerid,ht5, ta.valuewhen(barstate.isconfirmed, open, 0))
highHt5=request.security(syminfo.tickerid,ht5, high)
lowHt5=request.security(syminfo.tickerid,ht5, low)
closeHt5=request.security(syminfo.tickerid,ht5, ta.valuewhen(barstate.isconfirmed, close, 0))

//labels
bullHt1=closeHt1 > openHt1
if lblHt1 and ta.change(bullHt1)
    label.new(bar_index, bullHt1?low:high, ht1, color = bullHt1?color.green:color.red, style = bullHt1?label.style_label_up:label.style_label_down, size = size.tiny, yloc = bullHt1?yloc.belowbar:yloc.abovebar)
bullHt2=closeHt2 > openHt2
if lblHt2 and ta.change(bullHt2)
    label.new(bar_index, bullHt2?low:high, ht2, color = bullHt2?color.green:color.red, style = bullHt2?label.style_label_up:label.style_label_down, size = size.small, yloc = bullHt2?yloc.belowbar:yloc.abovebar)
bullHt3=closeHt3 > openHt3
if lblHt3 and ta.change(bullHt3)
    label.new(bar_index, bullHt3?low:high, ht3, color = bullHt3?color.green:color.red, style = bullHt3?label.style_label_up:label.style_label_down, size = size.small, yloc = bullHt3?yloc.belowbar:yloc.abovebar)
bullHt4=closeHt4 > openHt4
if lblHt4 and ta.change(bullHt4)
    label.new(bar_index, bullHt4?low:high, ht4, color = bullHt4?color.green:color.red, style = bullHt4?label.style_label_up:label.style_label_down, size = size.small, yloc = bullHt4?yloc.belowbar:yloc.abovebar)
bullHt5=closeHt5 > openHt5
if lblHt5 and ta.change(bullHt5)
    label.new(bar_index, bullHt5?low:high, ht5, color = bullHt5?color.green:color.red, style = bullHt5?label.style_label_up:label.style_label_down, size = size.small, yloc = bullHt5?yloc.belowbar:yloc.abovebar)

//display table
var tbl = table.new(position.bottom_right, 2, 7)
table.cell(tbl, 0, 0, "BarsOnHTF", bgcolor = #aaaaaa)
table.cell(tbl, 1, 0, "",  bgcolor = #aaaaaa, width = 4, height = 4)

table.merge_cells(tbl, 0, 0, 1, 0)

table.cell(tbl, 0, 1, "TF",  bgcolor = #aaaaaa, width = 4, height = 4, text_halign = text.align_left)
table.cell(tbl, 1, 1, "close", bgcolor = #aaaaaa, width = 4, height = 4)

table.cell(tbl, 0, 2, ht5,  bgcolor = #aaaaaa, width = 4, height = 4, text_halign = text.align_left)
table.cell(tbl, 1, 2, str.tostring(closeHt5), bgcolor = closeHt5>openHt5? color.green:color.red, width = 4, height = 4)

table.cell(tbl, 0, 3, ht4,  bgcolor = #aaaaaa, width = 4, height = 4, text_halign = text.align_left)
table.cell(tbl, 1, 3, str.tostring(closeHt4), bgcolor = closeHt4>openHt4? color.green:color.red, width = 4, height = 4)

table.cell(tbl, 0, 4, ht3,  bgcolor = #aaaaaa, width = 4, height = 4, text_halign = text.align_left)
table.cell(tbl, 1, 4, str.tostring(closeHt3), bgcolor = closeHt3>openHt3? color.green:color.red, width = 4, height = 4)

table.cell(tbl, 0, 5, ht2,  bgcolor = #aaaaaa, width = 4, height = 4, text_halign = text.align_left)
table.cell(tbl, 1, 5, str.tostring(closeHt2), bgcolor = closeHt2>openHt2? color.green:color.red, width = 4, height = 4)

table.cell(tbl, 0, 6, ht1,  bgcolor = #aaaaaa, width = 4, height = 4, text_halign = text.align_left)
table.cell(tbl, 1, 6, str.tostring(closeHt1), bgcolor = closeHt1>openHt1? color.green:color.red, width = 4, height = 4)

//EOF
