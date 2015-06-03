'**********************************************************
'**  Video Player Example Application - Video Playback
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'**********************************************************

'***********************************************************
'** Create and show the video screen.  The video screen is
'** a special full screen video playback component.  It
'** handles most of the keypresses automatically and our
'** job is primarily to make sure it has the correct data
'** at startup. We will receive event back on progress and
'** error conditions so it's important to monitor these to
'** understand what's going on, especially in the case of errors
'***********************************************************

Function showVideoScreen(episode As Object)

    print "showVideoScreen"

    if type(episode) <> "roAssociativeArray" then
        print "invalid data passed to showVideoScreen"
        return -1
    endif

    port = CreateObject("roMessagePort")
    screen = CreateObject("roVideoScreen")
    screen.SetMessagePort(port)

    screen.SetPositionNotificationPeriod(30)
    screen.SetContent(episode)
    screen.Show()

    'Uncomment his line to dump the contents of the episode to be played
    'PrintAA(episode)

    globals = getGlobalAA()

    position = 0
    episode.playStart = position

    duration = episode.length

    ' Prevent events being recorded again after resume
    reachedFirstQuartile = (position > duration * 0.25)
    reachedMidpoint = (position > duration * 0.5)
    reachedThirdQuartile = (position > duration * 0.75)

    ' set some analytics
    globals.analytics = Analytics()

    episodeUrl   = episode.ItemUrl + "/watching"

    if episode.Series = "" then
      episodeTitle = "WATCHING | " + episode.Title
    else
      episodeTitle = "WATCHING | " + episode.Series + " - " + episode.Title
    endif

    globals.analytics.trackEvent("pageview", episodeUrl, episodeTitle, "", "", "")

    while true
        msg = wait(0, port)

        if type(msg) = "roVideoScreenEvent" then
            print "showHomeScreen | msg = "; msg.getMessage() " | index = "; msg.GetIndex()
            if msg.isScreenClosed()
                print "Screen closed"
                exit while
            elseif msg.isRequestFailed()
                print "Video request failure: "; msg.GetIndex(); " " msg.GetData()
                globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Error", "Video Reqest Failure", episodeTitle)
            elseif msg.isStatusMessage()
                print "Video status: "; msg.GetIndex(); " " msg.GetData()
            elseif msg.isButtonPressed()
                print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
            else if msg.isStreamStarted()
                globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Started", "Started", episodeTitle)
            else if msg.isFullResult()
                position = 0

                playtime = position - episode.playStart

                globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Finish", "Finish", episodeTitle)
                globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Completion", "Completion - 100%", episodeTitle)

                exit while
            else if msg.isPartialResult()
                playtime = position - episode.playStart

                if episode.length <> 0 then
                    stoppedAtPct = int(position / episode.length * 100).toStr()
                else
                    stoppedAtPct = "N/A"
                end if

                globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Stop", playtime.toStr(), episodeTitle)

                ' If user watched more than 95% count video as watched
                if episode.length <> 0 and position >= int(episode.length * 0.95) then
                    position = 0

                    globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Finish", "Finish", episodeTitle)
                    globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Completion", "Completion - 100%", episodeTitle)
                end if
            elseif msg.isPlaybackPosition() then
                position = msg.GetIndex()

                if position > position * 0.25 and reachedFirstQuartile = false then
                    globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Completion", "Completion - 25%", episodeTitle)
                end if

                if position > position * 0.5 and reachedMidpoint = false then
                    globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Completion", "Completion - 50%", episodeTitle)
                end if

                if position > position * 0.75 and reachedThirdQuartile = false then
                    globals.analytics.trackEvent("event", episodeUrl, episodeTitle, "Completion", "Completion - 75%", episodeTitle)
                end if
            else
                print "Unexpected event type: "; msg.GetType()
            end if
        else
            print "Unexpected message class: "; type(msg)
        end if
    end while

End Function

