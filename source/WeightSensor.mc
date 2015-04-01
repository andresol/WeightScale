using Toybox.Ant as Ant;
using Toybox.System as Sys;

class WeightSensor extends Ant.GenericChannel {
	const DEVICE_TYPE = 0x77;
    const PERIOD = 8192;
	static const MOBILE_PROFILE_ID = 0x0111;
    hidden var chanAssign;
	const PROFILE_PAGE_NUMNBER = 0x3A;

    var data;
    var searching;
    var pastEventCount;
    var deviceCfg;
    var debug;

    class WeightData
    {
        var weight;
        var eventCount;
        var utcTimeSet;
       

        function initialize()
        {
            weight = 0;
            eventCount = 0;
            utcTimeSet = false;
        }
    }
    
    class WeightDataPage
    {
        var pageNumber = 0;
        

        function parse(payload, data)
        {
        	pageNumber = (payload[0].toNumber() & 0xFF);
        	if (pageNumber == 1) { //TODO: Parse datapage 2 body comp
	            data.eventCount = data.eventCount + 1;
	            data.weight = parseWeight(payload);
            } 
            
        }

        hidden function parseWeight(payload)
        {
          return ((payload[6] | ((payload[7] & 0x0F) << 8))) / 100f;
        }

    }

  
    function initialize()
    {
        // Get the channel
        chanAssign = new Ant.ChannelAssignment(
            Ant.CHANNEL_TYPE_RX_NOT_TX,
            Ant.NETWORK_PLUS);
        GenericChannel.initialize(method(:onMessage), chanAssign);

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => 0,                 //Wildcard our search
            :deviceType => DEVICE_TYPE,
            :transmissionType => 0,
            :messagePeriod => PERIOD,
            :radioFrequency => 0x39,             //Ant+ Frequency
            :searchTimeoutLowPriority => 12,    //Timeout in 25s
            :searchTimeoutHighPriority => 2,    //Timeout in 5s
            :searchThreshold => 1} );           //Pair to the closest transmitting sensors
        GenericChannel.setDeviceConfig(deviceCfg);

        data = new WeightData();
        searching = true;
        debug = "";
    }

    function open()
    {
        // Open the channel
        GenericChannel.open();
		Sys.println("Open channel");
        data = new WeightData();
        pastEventCount = 0;
        searching = true;
    }
    
  

    function closeSensor()
    {
        GenericChannel.close();
    }


    function onMessage(msg)
    {
        // Parse the payload
		Sys.println("Getting message.");
        var payload = msg.getPayload();
        debug = "" + msg.messageId;
		Ui.requestUpdate();
		
        if( Ant.MSG_ID_BROADCAST_DATA == msg.messageId )
        {
                // Were we searching?
                if(searching)
                {
                    searching = false;
                    // Update our device configuration primarily to see the device number of the sensor we paired to
                    deviceCfg = GenericChannel.getDeviceConfig();
                }
            	var dp = new WeightDataPage();
                dp.parse(payload, data);
                // Check if the data has changed and we need to update the ui
               // if(pastEventCount != data.eventCount)
               // {
                    Ui.requestUpdate();
                  //  pastEventCount = data.eventCount;
                //}
        }
        else if( Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId )
        {
        	
            if( Ant.MSG_ID_RF_EVENT == (payload[0] & 0xFF) )
            {
                if( Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == (payload[1] & 0xFF) )
                {
                    // Channel closed, re-open
					Sys.println("reopen");
                    open();
                  
                }
                else if( Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH  == (payload[1] & 0xFF) )
                {
                    searching = true;
                    Ui.requestUpdate();
                    Sys.println("Searching");
                    
                }
            }
            else
            {
                //It is a channel response.
            }
            Sys.println("Sending profile");
              var payload = new [8];
               profileData[0] = 0x3A;
                    profileData[1] = 0xFF;
                    profileData[2] = 0xFF;
                    profileData[3] = 0xFF;
                    profileData[4] = 0xFF;
                    profileData[5] = 0x00;
                    profileData[6] = 0x00;
                    profileData[7] = 0xFF;
            var message = new Ant.Message();
            message.setPayload(payload);
            GenericChannel.sendBroadcast(message);
        } else {
        	Sys.println("Error");
        }
    }

}