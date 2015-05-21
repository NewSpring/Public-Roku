NewSpring Staff Roku App
------------------------

This is a single screen live streaming app for Roku. I created it because
clicking through 5 different menu screens is unnecessary and inefficient.

Setup
-----

Make sure you put your roku in [dev mode](http://sdkdocs.roku.com/display/sdkdoc/Developer+Guide#DeveloperGuide-71EnablingDevelopmentModeonyourbox). Compiling the app is as simple as running `make` from the `apps/source/staff` directory. Install or Replace your app on your Roku box to test. You can telnet into the box and see any debugging output that might have been printed if your app didn't run as expected.

You can also read Roku's extensive documentation at http://sdkdocs.roku.com/

Notes
-----

Parts of this app use code from the `simplevideoplayer` app listed in the
documentation above. I noted in the `appMain.brs` file where this happened.

License
-------

See [LICENSE](https://github.com/NewSpring/Staff-Roku/blob/master/LICENSE)
