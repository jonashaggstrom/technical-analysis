// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © pikebay 2022

//@version=5
indicator("TimeframeBoxes[Pikebay]", overlay=true)


// Input options
limitBar=input.float(defval=0.6, title="RangeLimit(Bar)(%)", minval=0.1, maxval=100.0, step=0.1, group="bar" )
showEntryLbl=input.bool(defval=false, title="Show Range Limit Break label", group="bar" )

string tfInput = input.timeframe("D", "HTimeframe", group="HT" )
limitHT=input.float(defval=1.2, title="RangeLimit(HT)(%)", minval=0.1, maxval=100.0, step=0.1, group="HT" )
showHTBox=input.bool(defval=true, title="TF Box", group="HT", inline="box"), showHTEnd=input.bool(defval=true, title="TF end ", group="HT", inline="box" ),boxBorderSize = input.int(2, title="border", minval=0, group="HT", inline="box" )
upBoxColor        = input.color(color.new(color.green, 85), title="Up colour", group="HT", inline="upColor"),upBorderColor= input.color(color.green, title="border", group="HT", inline="upColor")
downBoxColor      = input.color(color.new(color.red, 85), title="Down colour", group="HT", inline="downColor"),downBorderColor= input.color(color.red, title="border", group="HT", inline="downColor")
rangeBreakBoxColor= input.color(color.new(color.purple, 85), title="Range Break colour", group="HT")
joinBoxes = input.bool(false, title="Join boxes", group="HT")

// Create variables
var dayHighPrice = 0.0
var dayLowPrice  = 0.0
var prevDayClose = 0.0
var box dailyBox = na
var box leftOverBox = na
dClose=request.security(syminfo.tickerid,tfInput,close)

// See if a new calendar day started on the intra-day time frame
newDayStart = dayofmonth != dayofmonth[1] and 
     timeframe.isintraday
newTf=timeframe.change(tfInput) and 
     timeframe.isintraday

// If a new day starts, set the high and low to that bar's data. Else
// during the day track the highest high and lowest low.
if newTf
    dayHighPrice := high
    dayLowPrice  := low
    prevDayClose := close[1]
else
    dayHighPrice := math.max(dayHighPrice, high)
    dayLowPrice  := math.min(dayLowPrice, low)
theBoxRange=((dayHighPrice - dayLowPrice)/prevDayClose)*100.0

timeCloseTF=request.security(syminfo.tickerid, tfInput, ta.valuewhen(newTf, time_close, 0))
timeLeftTF=request.security(syminfo.tickerid, tfInput, time_close - timenow)
if showHTBox
    // When a new day start, create a new box for that day.
    // Else, during the day, update that day's box.
    if newTf
        dailyBox := box.new(left=bar_index, top=dayHighPrice, right=bar_index, bottom=dayLowPrice, border_width=0)
        box.set_border_width(dailyBox, 0)
        // If we don't want the boxes to join, the previous box shouldn't
        // end on the same bar as the new box starts.
        if not joinBoxes
            box.set_right(dailyBox[1], bar_index[1])
    else
        box.set_border_width(dailyBox, boxBorderSize)
        box.set_top(dailyBox, dayHighPrice)
        box.set_rightbottom(dailyBox, right=timeLeftTF==0?bar_index[1]:bar_index, bottom=dayLowPrice)

        // If the current bar closed higher than yesterday's close, make
        // the box green (and paint it red otherwise)
        if close > prevDayClose
            box.set_bgcolor(dailyBox, upBoxColor)
            box.set_border_color(dailyBox, upBorderColor)
        else
            box.set_bgcolor(dailyBox, downBoxColor)
            box.set_border_color(dailyBox, downBorderColor)
        if theBoxRange > limitHT
            box.set_bgcolor(dailyBox, rangeBreakBoxColor)
            box.set_border_color(dailyBox, color.black)
if showHTEnd
    if newTf
        leftOverBox:= box.new(left=time, top=dayHighPrice, right=timeCloseTF-(timeframe.multiplier*60*1000), bottom=dayLowPrice, border_color = color.gray ,border_style =line.style_dashed, bgcolor = na ,border_width=1, xloc = xloc.bar_time)
    else
        box.set_top(leftOverBox, dayHighPrice)
        box.set_rightbottom(leftOverBox, right=timeCloseTF-(timeframe.multiplier*60*1000), bottom=dayLowPrice)
theRange=((high - low)/prevDayClose)*100.0
if(theRange > limitBar)
    if showEntryLbl
        if(close < open)
            label.new(bar_index, low, text="S", yloc= yloc.abovebar, color=color.red, style=label.style_label_down, size=size.tiny)
        else
            label.new(bar_index, low, text="B", yloc= yloc.belowbar, color=color.green, style=label.style_label_up, size=size.tiny)
barcolor(theRange > limitBar ? color.purple : na)

//EOF
