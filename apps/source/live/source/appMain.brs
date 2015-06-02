'********************************************************************
'**  Video Player Example Application - Main
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'********************************************************************

Sub Main()

    'initialize theme attributes like titles, logos and overhang color
    initTheme()

    'prepare the screen for display and get ready to begin
    screen=preShowHomeScreen("", "")
    if screen=invalid then
        print "unexpected error in preShowHomeScreen"
        return
    end if

    'set to go, time to get started
    showHomeScreen(screen)

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

    theme.OverhangOffsetHD_X = "125"
    theme.OverhangOffsetHD_Y = "35"
    theme.OverhangSliceHD = "pkg:/images/overhang.background.hd.png"
    theme.OverhangLogoHD  = "pkg:/images/overhang.logo.hd.png"

    theme.FilterBannerActiveColor     = "#6BAC43"
    theme.FilterBannerInactiveColor   = "#858585"
    theme.FilterBannerSideColor       = "#858585"

    theme.FilterBannerActiveHD        = "pkg:/images/transparent.png"
    theme.FilterBannerActiveSD        = "pkg:/images/transparent.png"
    theme.FilterBannerInactiveHD      = "pkg:/images/transparent.png"
    theme.FilterBannerInactiveSD      = "pkg:/images/transparent.png"

    theme.FilterBannerSliceHD         = "pkg:/images/filterbg.png"
    theme.FilterBannerSliceSD         = "pkg:/images/filterbg.png"

    theme.BackgroundColor             = "#F9F9F9"
    theme.GridScreenRetrievingColor   = "#858585"

    theme.ButtonHighlightColor        = "#6BAC43"

    theme.PosterScreenLine1Text       = "#303030"
    theme.PosterScreenLine2Text       = "#858585"

    theme.SpringboardActorColor         = "#303030"

    theme.SpringboardRuntimeColor       = "#858585"
    theme.SpringboardSynopsisColor      = "#858585"
    theme.SpringboardTitleText          = "#303030"

    theme.ButtonHighlightColor          = "#858585"
    theme.ButtonMenuHighlightText       = "#6BAC43"
    theme.ButtonMenuNormalOverlayText   = "#858585"
    theme.ButtonMenuNormalText          = "#858585"
    theme.ButtonNormalColor             = "#858585"

    ' Poster Active Image
    theme.ListItemHighlightHD           = "pkg:/images/transparent.png"
    theme.ListItemHighlightSD           = "pkg:/images/transparent.png"

    theme.GridScreenFocusBorderHD       = "pkg:/images/GridScreenFocusBorderHD.png"
    theme.GridScreenFocusBorderSD       = "pkg:/images/GridScreenFocusBorderHD.png"

    app.SetTheme(theme)

End Sub
