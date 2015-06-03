<<<<<<< HEAD
'
' Analytics module based on code from the Plex Roku client.
'
' Original code: https://github.com/plexinc/roku-client-public/blob/master/Plex/source/Analytics.brs
' License to use explicitly granted: https://github.com/plexinc/roku-client-public/issues/233#issuecomment-15557688
' The Plex code was itself based on: http://bloggingwordpress.com/2012/04/google-analytics-for-roku-developers/
' Original licenses follows: 
'

REM *****************************************************
REM   Google Analytics Tracking Library for Roku
REM   GATracker.brs - Version 2.0
REM   (C) 2012, Trevor Anderson, BloggingWordPress.com
REM   Permission is hereby granted, free of charge, to any person obtaining a copy of this software
REM   and associated documentation files (the "Software"), to deal in the Software without restriction,
REM   including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
REM   and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
REM   subject to the following conditions:
REM
REM   The above copyright notice and this permission notice shall be included in all copies or substantial
REM   portions of the Software.
REM
REM   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
REM   LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
REM   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
REM   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
REM   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
REM *****************************************************

function visitorId() as String

    serialNumber = GetDeviceESN()
    rokuId = Right(serialNumber, 6)
    
    return rokuId

end function

function Analytics() as Object

    this = {}

    this.account = "UA-7130289-23"
    this.appName = "roku-newspring"
    this.domain = "newspring.cc"
    this.numEvents = 0
    this.numWatched = 0
    this.numFinished = 0
    this.baseUrl = ""
    
    this.sessionTimer = createObject("roTimespan")

    this.startup = Analytics_startup
    this.shutdown = Analytics_shutdown
    this.trackEvent = Analytics_trackEvent
    this._formatEvent = _Analytics_formatEvent
    this._formatCustomVars = _Analytics_formatCustomVars
    this._random = _Analytics_random

    xfer = createObject("roUrlTransfer")
    device = createObject("roDeviceInfo")
    screenSize = device.getDisplaySize()

    this.baseUrl = "http://www.google-analytics.com/collect"
    this.baseUrl = this.baseUrl + "?v=1"
    this.baseUrl = this.baseUrl + "&tid=" + this.account
    this.baseUrl = this.baseUrl + "&cid=" + visitorId()
    this.baseUrl = this.baseUrl + "&dr=roku"
    
    ' this.baseUrl = this.baseUrl + "&utmsr=" + screenSize.w.toStr() + "x" + screenSize.h.toStr()
    ' this.baseUrl = this.baseUrl + "&utmsc=24-bit"
    ' this.baseUrl = this.baseUrl + "&utmul=" + device.getCurrentLocale()
    ' this.baseUrl = this.baseUrl + "&utmje=0"
    ' this.baseUrl = this.baseUrl + "&utmfl=-"
    ' this.baseUrl = this.baseUrl + "&utmdt=" + xfer.Escape(this.appName)
    ' this.baseUrl = this.baseUrl + "&utmp=" + xfer.Escape(this.appName)
    ' this.baseUrl = this.baseUrl + "&utmhn=" + xfer.Escape(this.domain)
    ' this.baseUrl = this.baseUrl + "&utmr=-"
    ' this.baseUrl = this.baseUrl + "&utmvid=" + xfer.Escape(device.getDeviceUniqueId())

    ' this.baseUrl = this.baseUrl + "&utmcc=__utma%3D" + "."
    ' this.baseUrl = this.baseUrl + "%3B%2B__utmb%3D" + ".0.10." + "000"
    ' sthis.baseUrl = this.baseUrl + "%3B%2B__utmc%3D" + ".0.10." + "000"

    return this 

end function

function GetRandomInt(length As Integer) As String
    hexChars = "0123456789"
    hexString = ""
    for i = 1 to length
        hexString = hexString + hexChars.Mid(Rnd(16) - 1, 1)
    next
    return hexString
end function

function Analytics_trackEvent(category, action, label, value, title)

    this = m

    if action = "Start" or action = "Continue" then
        this.numWatched = this.numWatched + 1
    end if

    if action = "Finish" then
        this.numFinished = this.numFinished + 1
    end if

    RegWrite("sessionDuration", this.sessionTimer.TotalSeconds().toStr(), "analytics")
    RegWrite("sessionNumWatched", this.numWatched.toStr(), "analytics")
    RegWrite("sessionNumFinished", this.numFinished.toStr(), "analytics")

    this.numEvents = this.numEvents + 1

    url = this.baseUrl
    ' url = url + "&utms=" + this.numEvents.toStr()
    ' url = url + "&utmn=" + this._random(1000000000, 9999999999).toStr()
    ' url = url + "&utmac=" + this.account
    ' url = url + "&utmt=event"
    url = url + "&t=" + category
    url = url + "&dp=" + label
    url = url + "&dt=" + title
    ' url = url + "&ec=" + eventCategory
    ' url = url + "&ea=" + eventAction
    ' url = url + "&et=" + eventLabel
    

    httpGetWithRetry(url, 2000, 0)

end function

' Do initial analytics reporting
function Analytics_startup()

    this = m 
    
    device = createObject("roDeviceInfo")

    this.trackEvent("pageview", "Startup", "roku", "", "Roku%20Homescreen")

end function

' Do final analytics reporting
function Analytics_shutdown()

    this = m

    RegWrite("session_duration", this.sessionTimer.TotalSeconds().toStr(), "analytics")

end function

' Format event for request string 
Function _Analytics_formatEvent(category, action, label, value) As String

    xfer = createObject("roUrlTransfer")

    event = "5(" + xfer.Escape(category) + "*" + xfer.Escape(action)
    
    if label <> invalid then
        event = event + "*" + xfer.Escape(label)
    end if
    
    if value <> invalid then
        event = event + ")(" + value
    end if

    event = event + ")"

    return event

End Function

' Format custom variables for request string
Function _Analytics_formatCustomVars(vars) As String

    xfer = createObject("roUrlTransfer")

    if vars.count() = 0 then
        return ""
    end if

    names = "8"
    values = "9"
    scopes = "11"
    skipped = false

    for i = 0 to vars.count() - 1
        if vars[i] <> invalid then
            if i = 0 then
                prefix = "("
            else if skipped then
                prefix = i.toStr() + "!"
            else
                prefix = "*"
            end if

            names = names + prefix + xfer.Escape(vars[i].name)
            values = values + prefix + xfer.Escape(vars[i].value)

            if vars[i] <> invalid then
                scope = "3"
            else
                scope = "2"
            end if

            scopes = scopes + prefix + scope
        else
            skipped = true
        end if
    end for

    names = names + ")"
    values = values + ")"
    scopes = scopes + ")"

    return names + values + scopes

End Function

' Generate a random number suitable for analytics
Function _Analytics_random(num_min As Integer, num_max As Integer) As Integer

    Return (RND(0) * (num_max - num_min)) + num_min

End Function