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

' Returns the last 6 numbers of the device esn to use as GA visitorId
function visitorId() as String

    serialNumber = GetDeviceESN()
    rokuId = Right(serialNumber, 6)

    return rokuId

end function

function Analytics() as Object

    this = {}

    this.account = "UA-7130289-37"
    this.appName = "roku-kidspring"
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

function Analytics_trackEvent(hitType, documentLocation, pageTitle, eventCategory, eventAction, eventLabel)

    this = m

    if eventAction = "Start" or eventAction = "Continue" then
        this.numWatched = this.numWatched + 1
    end if

    if eventAction = "Finish" then
        this.numFinished = this.numFinished + 1
    end if

    RegWrite("sessionDuration", this.sessionTimer.TotalSeconds().toStr(), "analytics")
    RegWrite("sessionNumWatched", this.numWatched.toStr(), "analytics")
    RegWrite("sessionNumFinished", this.numFinished.toStr(), "analytics")

    this.numEvents = this.numEvents + 1

    ' URL Encoding for documentLocation
    xfer = createObject("roUrlTransfer")

    url = this.baseUrl
    url = url + "&t=" + hitType
    url = url + "&dl=" + xfer.Escape(documentLocation)
    url = url + "&dt=" + xfer.Escape(pageTitle)

    if eventCategory <> "" then
      url = url + "&ec=" + xfer.Escape(eventCategory)
    end if

    if eventAction <> "" then
      url = url + "&ea=" + xfer.Escape(eventAction)
    end if

    if eventLabel <> "" then
      url = url + "&el=" + xfer.Escape(eventLabel)
    end if

    httpGetWithRetry(url, 2000, 0)

end function

' Do initial analytics reporting
function Analytics_startup()

    this = m

    device = createObject("roDeviceInfo")

    startUrl = "http://newspring.cc/roku"

    this.trackEvent("pageview", startUrl, "Roku Homescreen", "", "", "")

end function

' Do final analytics reporting
function Analytics_shutdown()

    this = m

    RegWrite("session_duration", this.sessionTimer.TotalSeconds().toStr(), "analytics")

end function

' Format event for request string
Function _Analytics_formatEvent(hitType, documentLocation, pageTitle, eventCategory, eventAction, eventLabel) As String

    xfer = createObject("roUrlTransfer")

    event = "5(" + xfer.Escape(hitType) + "*"

    if documentLocation <> invalid then
        event = event + "*" + xfer.Escape(documentLocation)
    end if

    if pageTitle <> invalid then
        event = event + ")(" + pageTitle
    end if

    if eventCategory <> "" then
      event = event + ")(" + eventCategory
    end if

    if eventAction <> "" then
      event = event + ")(" + eventAction
    end if

    if eventLabel <> "" then
      event = event + ")(" + xfer.Escape(eventLabel)
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