using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class WeightScaleView extends Ui.View {
	hidden var wSensor;
    hidden var wIndicator;
	
	 function initialize(sensor)
    {
        wSensor = sensor;
        wIndicator = new PageIndicator();
        var size = 1;
        var selected = Gfx.COLOR_DK_GRAY;
        var notSelected = Gfx.COLOR_LT_GRAY;
        var alignment = wIndicator.ALIGN_BOTTOM_RIGHT;
        wIndicator.setup(size, selected, notSelected, alignment, 0);
    }
    //! Load your resources here
    function onLayout(dc) {
        //setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var margin = 75;
        var font = Gfx.FONT_SMALL;

        // Show icon
        //dc.drawBitmap(width/5, margin, mIcon);
//
        // Update status
		Sys.println("updateGUI");
        if(true == wSensor.searching)
            {
	            var status = "searching...";
	            status +=  wSensor.debug;
	            var fWidth = dc.getTextWidthInPixels(status, font);
	            dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT );
	            dc.drawText(width/2 - fWidth/2, height-margin, font, status, Gfx.TEXT_JUSTIFY_LEFT);
            }
        else
            {
	            var deviceNumber = mSensor.deviceCfg.deviceNumber;
	            var status = "tracking - " + deviceNumber.toString();
	            var fWidth = dc.getTextWidthInPixels(status, font);
	            dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT );
	            dc.drawText(width/2 - fWidth/2, height-margin, Gfx.FONT_SMALL, status, Gfx.TEXT_JUSTIFY_LEFT);
            }

        // Draw page indicator
        wIndicator.draw(dc, 1);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

}