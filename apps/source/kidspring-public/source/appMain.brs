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
    theme.OverhangOffsetSD_Y = "0"
    theme.OverhangSliceSD = "pkg:/images/overhang.background.sd.png"
    theme.OverhangLogoSD  = "pkg:/images/overhang.logo.sd.png"

    theme.OverhangOffsetHD_X = "60"
    theme.OverhangOffsetHD_Y = "0"
    theme.OverhangSliceHD = "pkg:/images/overhang.background.hd.png"
    theme.OverhangLogoHD  = "pkg:/images/overhang.logo.hd.png"

    theme.FilterBannerActiveColor     = "#FFFFFF"
    theme.FilterBannerInactiveColor   = "#FFFFFF"
    theme.FilterBannerSideColor       = "#FFFFFF"

    theme.FilterBannerActiveHD        = "pkg:/images/transparent.png"
    theme.FilterBannerActiveSD        = "pkg:/images/transparent.png"
    theme.FilterBannerInactiveHD      = "pkg:/images/transparent.png"
    theme.FilterBannerInactiveSD      = "pkg:/images/transparent.png"

    theme.FilterBannerSliceHD         = "pkg:/images/filterbg.png"
    theme.FilterBannerSliceSD         = "pkg:/images/filterbg.png"

    theme.BreadcrumbTextLeft          = "#FFFFFF"
    theme.BreadcrumbTextRight         = "#FFFFFF"
    theme.BreadcrumbDelimiter         = "#8BC541"

    theme.BackgroundColor             = "#FFFFFF"
    theme.GridScreenRetrievingColor   = "#8BC541"

    theme.ButtonHighlightColor        = "#8BC541"

    theme.PosterScreenLine1Text       = "#0081C5"
    theme.PosterScreenLine2Text       = "#1A1A1A"

    theme.SpringboardActorColor         = "#1A1A1A"

    theme.SpringboardRuntimeColor       = "#1A1A1A"
    theme.SpringboardSynopsisColor      = "#1A1A1A"
    theme.SpringboardTitleText          = "#1A1A1A"

    theme.ButtonHighlightColor          = "#8BC541"
    theme.ButtonMenuHighlightText       = "#8BC541"
    theme.ButtonMenuNormalOverlayText   = "#8BC541"
    theme.ButtonMenuNormalText          = "#8BC541"
    theme.ButtonNormalColor             = "#8BC541"

    ' Poster Active Image
    ' theme.ListItemHighlightHD           = "pkg:/images/filterbg.png"
    ' theme.ListItemHighlightSD           = "pkg:/images/filterbg.png"

    ' theme.GridScreenFocusBorderHD       = "pkg:/images/filterbg.png"
    ' theme.GridScreenFocusBorderSD       = "pkg:/images/filterbg.png"

    ' Light Up Colfax

    ' fontReg = CreateObject("roFontRegistry")
    '     fontReg.Register("pkg:/fonts/medium.eot")
    '     font = fontReg.Get("Colfax Medium",28,50,true)

    app.SetTheme(theme)

End Sub
