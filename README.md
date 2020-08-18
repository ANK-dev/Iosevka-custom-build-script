# Iosevka-custom-build-script
Simple build script for building a custom version of [Iosevka](https://github.com/be5invis/Iosevka) on Windows


## Prerequisites

Install [node.js](https://nodejs.org) and [Git](https://git-scm.com) (Preferably).

Download [ttfautohint](https://www.freetype.org/ttfautohint/#download) and [otfcc](https://github.com/caryll/otfcc/releases/). Extract both archives and place the executables in `.\ttfautohint\` and `.\otfcc\`, respectively.


## Setup

Place the `build.bat` in the `.\` directory. Run the script once, and the "Iosevka" repository will be cloned. Edit (or create) the `private-build-plans.toml` with your custom font parameters.

A sample `private-build-plans.toml` is provided below:

~~~ toml
 [buildPlans.iosevka-custom]               # <iosevka-custom> is your plan name
 family = "Iosevka Custom"                 # Font menu family name
 design = ["v-i-hooky", "v-l-hooky"]       # Customize styles
 # upright = ["upright-styles"]            # Uncomment this line to set styles for upright only
 # italic = ["italic-styles"]              # Uncomment this line to set styles for italic only
 # oblique = ["oblique-styles"]            # Uncomment this line to set styles for oblique only
 # hintParams = ["-a", "sss"]              # Optional custom parameters for ttfautohint
 
 ###################################################################################################
 # Override default building weights
 # When buildPlans.<plan name>.weights is absent, all weights would built and mapped to
 # default values.
 # IMPORTANT : Currently "menu" and "css" property only support numbers between 0 and 1000.
 #             and "shape" properly only supports number between 100 and 900 (inclusive).
 #             If you decide to use custom weights you have to define all the weights you
 #             plan to use otherwise they will not be built.
 [buildPlans.iosevka-custom.weights.regular]
 shape = 400  # Weight for glyph shapes.
 menu  = 400  # Weight for the font's names.
 css   = 400  # Weight for webfont CSS.
 
 [buildPlans.iosevka-custom.weights.book]
 shape = 450
 menu  = 450  # Use 450 here to name the font's weight "Book"
 css   = 450
 
 [buildPlans.iosevka-custom.weights.bold]
 shape = 700
 menu  = 700
 css   = 700
 
 # End weight section
 ###################################################################################################
 
 ###################################################################################################
 # Override default building slope sets
 # Format: <upright|italic|oblique> = <"normal"|"italic"|"oblique">
 # When this section is absent, all slopes would be built.
 
 [buildPlans.iosevka-custom.slopes]
 upright = "normal"
 italic = "italic"
 oblique = "oblique"
 
 # End slope section
 ###################################################################################################
 
 ###################################################################################################
 # Override default building widths
 # When buildPlans.<plan name>.widths is absent, all widths would built and mapped to
 # default values.
 # IMPORTANT : Currently "shape" property only supports numbers between 434 and 664 (inclusive),
 #             while "menu" only supports integers between 1 and 9 (inclusive).
 #             The "shape" parameter specifies the unit width, measured in 1/1000 em. The glyphs'
 #             width are equal to, or a simple multiple of the unit width.
 #             If you decide to use custom widths you have to define all the widths you plan to use,
 #             otherwise they will not be built.
 
 [buildPlans.iosevka-custom.widths.normal]
 shape = 500        # Unit Width, measured in 1/1000 em.
 menu  = 5          # Width grade for the font's names.
 css   = "normal"   # "font-stretch' property of webfont CSS.
 
 [buildPlans.iosevka-custom.widths.extended]
 shape = 576
 menu  = 7
 css   = "expanded"
 
 # End width section
 ###################################################################################################
 
 ###################################################################################################
 # Character Exclusion
 # Specify character ranges in the section below to exclude certain characters from the font being
 # built. Remove this section when this feature is not needed.
 
 [buildPlans.iosevka-custom.exclude-chars]
 ranges = [[10003, 10008]]
 
 # End character exclusion
 ###################################################################################################
 
 ###################################################################################################
 # Compatibility Ligatures
 # Certain applications like Emacs does not support proper programming liagtures provided by
 # OpenType, but can support ligatures provided by PUA codepoints. Therefore you can edit the
 # following section to build PUA characters that are generated from the OpenType ligatures.
 # Remove this section when compatibility ligatures are not needed.
 
 [[buildPlans.iosevka-custom.compatibility-ligatures]]
 unicode = 57600 # 0xE100
 featureTag = 'calt'
 sequence = '<*>'
 
 # End compatibility ligatures section
 ###################################################################################################
 
 ###################################################################################################
 # Metric overrides
 # Certain metrics like line height (leading) could be overridden in your build plan file.
 # Edit the values to change the metrics. Remove this section when overriding is not needed.
 
 [buildPlans.iosevka-custom.metric-override]
 leading = 1250
 winMetricAscenderPad = 0
 winMetricDescenderPad = 0
 powerlineScaleY = 1
 powerlineScaleX = 1
 powerlineShiftY = 0
 powerlineShiftX = 0
 
 # End metric override section
 ###################################################################################################
 ~~~
 
## Bulding the font
 
Run the script again. When asked, type your _Build Plan_ name and which _Contents_ do you want to build. After the process is finished, access the `.\Iosevka\dist\` directory to get your custom font files.

## Credits

Script by [ANK-dev](https://github.com/ANK-dev), Iosevka by [Belleve Invis](https://github.com/be5invis)
