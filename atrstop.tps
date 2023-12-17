// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © pikebay aug 2022

//@version=5
indicator("AtrStop[Pikebay]", overlay=true)

//VWAP
cumulativePeriod = input(5, "Period", inline="atrinputs")
p=input(100,"Period",  inline="atrinputs")
m=input(11,"Multiplier", inline="atrinputs")

plotVwap=input.bool(false, "plotVwap", inline="vwapplot"), vwapLineW=input.int(1, "width", inline="vwapplot")
plotAtr=input(true, "plotAtr", inline="atrplot"), atrLineW=input.int(1, "width", inline="atrplot")

//HT
plotHT=input(true, "plotHT", inline="atrHT"),ht1=input.timeframe("15","Ht1", inline="atrHT"), atrHTLineW=input.int(1, "width", inline="atrHT")

//buyandsell
plotBSLines=input(false, "BuySell Lines", inline="bs"), bsLineW=input.int(1, "width", inline="bs"), bsLineExt=input.int(25, "Extend", inline="bs")
//ATR-Stop
typicalPrice = (high + low + close) / 3
typicalPriceVolume = typicalPrice * volume
cumulativeTypicalPriceVolume = math.sum(typicalPriceVolume, cumulativePeriod)
cumulativeVolume = math.sum(volume, cumulativePeriod)
vwapValue = cumulativeTypicalPriceVolume / cumulativeVolume

max=close[1]+ta.atr(p)[1]*m
min=close[1]-ta.atr(p)[1]*m
stop=min
hi=true
hi:=hi[1]?high[1]>=stop[1]?false:true:low[1]<=stop[1]?true:false
stop:=hi?max:min
stop:=hi?hi[1]==false?stop:stop>stop[1]?stop[1]:stop:hi[1]?stop:stop<stop[1]?stop[1]:stop

//VWAP-VWMA-ATR
atrLevel =(stop+vwapValue)/2

//atr select
atrLevelHT=request.security(syminfo.tickerid, ht1, (stop+vwapValue)/2)

//ATRCOLOR
atrcolor=(atrLevel>close?color.red:color.green)
atrcolorHT=(atrLevelHT>close?color.red:color.green)
atrPlot=plot(plotAtr?atrLevel:na,color=atrcolor,linewidth=atrLineW,title="ATR Trailing Stoploss")
atrHTPlot=plot(plotHT?atrLevelHT:na,color=atrcolorHT,linewidth=atrHTLineW,title="ATRHT Trailing Stoploss")
wvapPlot=plot(plotVwap?vwapValue:na,color=color.purple, linewidth = vwapLineW, title = "Vwap")
bothBull=atrLevel<close and atrLevelHT<close
bothBear=atrLevel>close and atrLevelHT>close
float buyLevel=na
buyLevel:=bothBull and not(bothBull[1])?close:buyLevel[1]
line buyLevelLine=na
float sellLevel=na
sellLevel:=bothBear and not(bothBear[1])?close:sellLevel[1]
line sellLevelLine=na

lastCross=0

if plotBSLines
    if ta.change(buyLevel)
        if(lastCross>0)
            line.delete(buyLevelLine)
        buyLevelLine:=line.new(bar_index,buyLevel,bar_index+bsLineExt,buyLevel, color = color.green, width = bsLineW)
        lastCross:=1
    else
        buyLevelLine:=buyLevelLine[1]
        buyLevelLine.set_x2(bar_index+bsLineExt)

    if ta.change(sellLevel)
        if(lastCross<0)
            line.delete(sellLevelLine)
        sellLevelLine:=line.new(bar_index,sellLevel,bar_index+bsLineExt,sellLevel, color = color.red, width = bsLineW)
        lastCross:=-1
    else
        sellLevelLine:=sellLevelLine[1]
        sellLevelLine.set_x2(bar_index+bsLineExt)
