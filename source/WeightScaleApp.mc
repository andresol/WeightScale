using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Sensor as Snsr;
using Toybox.System as Sys;

class WeightScaleApp extends App.AppBase {

	var wSensor;
    //! onStart() is called on application start up
    function onStart() {
     wSensor = new WeightSensor();
     Sys.println("Staring");
     wSensor.open();
    }

    //! onStop() is called when your application is exiting
    function onStop() {
  	  wSensor.release();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new WeightScaleView(wSensor), new WeightScaleDelegate(wSensor)];
    }

}

class WeightScaleDelegate extends Ui.InputDelegate {

    var wIndex;
    var wSensor;

    function initialize(sensor)
    {
        wSensor = sensor;
        wIndex = 1;
    }

    

    function getView(mIndex)
    {
       // var view;

        //if(0 == mIndex)
       // {
            view = new WeightScaleView(wSensor);
        //}
        //else if(1 == mIndex)
        //{
         //   view = new DataView(mSensor, mIndex);
        //}
        //else if(2 == mIndex)
       // {
        //    view = new GraphView(mSensor, mIndex);
        //}
        //else
        //{
         //   view = new CommandView(mSensor, mIndex);
        //}

        return view;
    }

    function getDelegate(mIndex)
    {
        var delegate = new WeightScaleDelegate(mSensor, 1);
        return delegate;
    }

}