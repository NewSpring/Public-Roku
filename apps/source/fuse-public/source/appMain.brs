'********************************************************************
'**  Video Player Example Application - Main
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'********************************************************************

Sub Main()

    print "Main"

    globals = getGlobalAA()

    ' set some analytics
    globals.analytics = Analytics()

    'initialize theme attributes like titles, logos and overhang color
    initTheme()

    'prepare the screen for display and get ready to begin
    screen=preShowHomeScreen("", "")
    if screen=invalid then
        print "unexpected error in preShowHomeScreen"
        return
    end if

    'app is done loading here, and home screen is about to show

    'set to go, time to get started
    showHomeScreen(screen)

    ' print "Shutting down"
    globals.analytics.shutdown()

End Sub


'*************************************************************
'** Set the configurable theme attributes for the application
'**
'** Configure the custom overhang and Logo attributes
'** Theme attributes affect the branding of the application
'** and are artwork, colors and offsets specific to the app
'*************************************************************

Sub initTheme()

    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")

    theme.OverhangOffsetSD_X = "72"
    theme.OverhangOffsetSD_Y = "31"
    theme.OverhangSliceSD = "pkg:/images/overhang.background.sd.png"
    theme.OverhangLogoSD  = "pkg:/images/overhang.logo.sd.png"

    theme.OverhangOffsetHD_X = "60"
    theme.OverhangOffsetHD_Y = "30"
    theme.OverhangSliceHD = "pkg:/images/overhang.background.hd.png"
    theme.OverhangLogoHD  = "pkg:/images/overhang.logo.hd.png"

    theme.FilterBannerActiveColor     = "#6BAC43"
    theme.FilterBannerInactiveColor   = "#656565"
    theme.FilterBannerSideColor       = "#656565"

    theme.FilterBannerActiveHD        = "pkg:/images/transparent.png"
    theme.FilterBannerActiveSD        = "pkg:/images/transparent.png"
    theme.FilterBannerInactiveHD      = "pkg:/images/transparent.png"
    theme.FilterBannerInactiveSD      = "pkg:/images/transparent.png"

    theme.FilterBannerSliceHD         = "pkg:/images/filterbg.png"
    theme.FilterBannerSliceSD         = "pkg:/images/filterbg.png"

    theme.BackgroundColor             = "#F9F9F9"
    theme.GridScreenRetrievingColor   = "#656565"

    theme.ButtonHighlightColor        = "#6BAC43"

    theme.PosterScreenLine1Text       = "#303030"
    theme.PosterScreenLine2Text       = "#656565"

    theme.SpringboardActorColor         = "#303030"

    theme.SpringboardRuntimeColor       = "#656565"
    theme.SpringboardSynopsisColor      = "#656565"
    theme.SpringboardTitleText          = "#303030"

    theme.ButtonHighlightColor          = "#656565"
    theme.ButtonMenuHighlightText       = "#6BAC43"
    theme.ButtonMenuNormalOverlayText   = "#656565"
    theme.ButtonMenuNormalText          = "#656565"
    theme.ButtonNormalColor             = "#656565"

    ' Light Up Colfax

    ' fontReg = CreateObject("roFontRegistry")
    '   fontReg.Register("https://d3n6tjerleuu41.cloudfront.net/fonts/colfax/medium.eot")
    '   font = fontReg.Get("Colfax Medium",28,50,true)

    '   text = {
    '        Text: "test",
    '        TextAttrs:{Color:"#303030", Font:font,
    '        HAlign:"Left", VAlign:"Top", Direction:"LeftToRight"}
    '      TargetRect:{x:50, y:20, w:700, h:100}}

    app.SetTheme(theme)

End Sub
