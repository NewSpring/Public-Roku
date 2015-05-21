'********************************************************************
'**  NewSpring Single Page Live Video
'**  November 2014
'**  Copyright (c) 2014 NewSpring Church Inc.
'**  Parts taken from Roku SDK are Noted
'********************************************************************

Sub Main()
    screen = createNewSpringScreen(false)
    port = CreateObject("roMessagePort")
    screen.setMessagePort(port)
    feed = getFeedObject()

    while true
      msg=wait(0, port)
      print "Msg: "; type(msg); "event: "; msg.GetInt()
        if type(msg) = "roUniversalControlEvent" then
          if msg.GetInt() = 6 or msg.GetInt() = 13 then
            showVideoScreen(feed)
          else
            screen = createNewSpringScreen(true)
            screen.setMessagePort(port)
          endif
        endif

        screen = createNewSpringScreen(true)
        screen.setMessagePort(port)
    end While
End Sub

Function createNewSpringScreen(line as Boolean) as Object
    black=&h303030FF
    green=&h6BAC43FF

    screen=CreateObject("roScreen")
    screen.SetAlphaEnable(true)
    screen.Clear(black)

    logo = CreateObject("roBitmap", "pkg:/images/newspring.logo.png")
    watch = CreateObject("roBitmap", "pkg:/images/newspring.watch.png")

    WatchLeft = (screen.getWidth()/2)-(watch.getWidth()/2)
    WatchTop = (screen.getHeight()/2)-((watch.getHeight()/2)-100)

    LogoLeft = (screen.getWidth()/2)-(logo.getWidth()/2)
    LogoTop = (screen.getHeight()/2)-((logo.getHeight()/2)+100)

    screen.drawObject(WatchLeft,WatchTop,watch)
    screen.drawObject(LogoLeft,LogoTop,logo)

    if line = true
      LineX = WatchTop + watch.getHeight() + 10
      LineY = WatchLeft

      screen.drawRect(LineY, LineX, watch.getWidth(), 5, green)
    endif

    return screen
End Function

'Most of this function is clipped together from the Roku SDK video example.
'I only want to parse on feed object.
Function getFeedObject() as Object
  'feed has to be http and not https
  liveFeed = "http://dev.newspring.cc/feeds/roku/public"

  http = NewHttp(liveFeed)
  rsp = http.GetToStringWithRetry()
  item = init_show_feed_item()
  xml = CreateObject("roXMLElement")
  if not xml.Parse(rsp) then
    print "Can't Parse Feed"
    return item
  endif

  if xml.GetName() <> "feed" then
        print "no feed tag found"
        return item
  endif

  if islist(xml.GetBody()) = false then
      print "no feed body found"
      return item
  endif

  feedData = xml.GetChildElements()

  for each feed in feedData
    if feed.GetName() = "resultLength" or feed.GetName() = "endIndex" then
      goto skipitem
    endif

    'fetch all values from the xml for the current show
    item.hdImg            = validstr(feed@hdImg)
    item.sdImg            = validstr(feed@sdImg)
    item.ContentId        = validstr(feed.contentId.GetText())
    item.Title            = validstr(feed.title.GetText())
    item.Description      = validstr(feed.description.GetText())
    item.ContentType      = validstr(feed.contentType.GetText())
    item.ContentQuality   = validstr(feed.contentQuality.GetText())
    item.Synopsis         = validstr(feed.synopsis.GetText())
    item.Genre            = validstr(feed.genres.GetText())
    item.Runtime          = validstr(feed.runtime.GetText())
    item.HDBifUrl         = validstr(feed.hdBifUrl.GetText())
    item.SDBifUrl         = validstr(feed.sdBifUrl.GetText())
    item.StreamFormat = validstr(feed.streamFormat.GetText())

    if item.StreamFormat = "" then  'set default streamFormat to mp4 if doesn't exist in xml
      item.StreamFormat = "mp4"
    endif

    if item.StreamFormat = "hls" Then
      item.SwitchingStrategy = "full-adaptation"
    End If

    'map xml attributes into screen specific variables
    item.ShortDescriptionLine1 = item.Title
    item.ShortDescriptionLine2 = item.Description
    item.HDPosterUrl           = item.hdImg
    item.SDPosterUrl           = item.sdImg

    item.Length = strtoi(item.Runtime)
    item.Categories = CreateObject("roArray", 5, true)
    item.Categories.Push(item.Genre)
    item.Actors = CreateObject("roArray", 5, true)
    item.Actors.Push(item.Genre)
    item.Description = item.Synopsis

    'Set Default screen values for items not in feed
    item.HDBranded = false
    item.IsHD = false
    item.Live = true
    item.PlayStart = 2000000
    item.StarRating = "90"
    item.ContentType = "episode"

    'media may be at multiple bitrates, so parse an build arrays
    for idx = 0 to 4
      e = feed.media[idx]
      if e  <> invalid then
        item.StreamBitrates.Push(strtoi(validstr(e.streamBitrate.GetText())))
        item.StreamQualities.Push(validstr(e.streamQuality.GetText()))
        item.StreamUrls.Push(validstr(e.streamUrl.GetText()))
      endif
    next idx

    skipitem:

  next

  return item
End Function

Function stubLivePlayback() as Object
  feed = init_show_feed_item()
  feed.ContentId = "one-hundred-thousand"
  feed.Title = "Sunday Service Live Stream"
  feed.ContentType = "episode"
  feed.ContentQuality = "HD"
  feed.RunTime = 5400
  feed.IsHD = true
  feed.Live = true
  feed.Genre = "church"
  feed.StreamFormat = "hls"
  feed.SwitchingStrategy = "full-adaptation"
  feed.StreamUrls.Push(validstr("<feedhere>"))
  feed.StreamQualities.Push(validstr("HD"))
  feed.StreamBitrates.Push(validstr("0"))
  return feed
End Function

'***********************************************************
' Initialize a ShowFeedItem. This sets the default values
' for everything.  The data in the actual feed is sometimes
' sparse, so these will be the default values unless they
' are overridden while parsing the actual game data
' FROM ROKU SDK EXAMPLE
'***********************************************************
Function init_show_feed_item() As Object
    o = CreateObject("roAssociativeArray")

    o.ContentId        = ""
    o.Title            = ""
    o.ContentType      = ""
    o.ContentQuality   = ""
    o.Synopsis         = ""
    o.Genre            = ""
    o.Runtime          = ""
    o.StreamQualities  = CreateObject("roArray", 5, true)
    o.StreamBitrates   = CreateObject("roArray", 5, true)
    o.StreamUrls       = CreateObject("roArray", 5, true)

    return o
End Function

