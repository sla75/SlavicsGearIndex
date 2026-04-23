import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

class SlavicsGearRearView extends SlavicsSimpleDataField {

    private var teethsLabel=new Text({
            :color=>Graphics.COLOR_DK_GRAY,
            :font=>Graphics.FONT_SMALL,
            :justification=>Graphics.TEXT_JUSTIFY_LEFT,
        });
        private var unitTeeths as String;

    function initialize() {
        System.println("SlavicsGearRearView.initialize()");
        SlavicsSimpleDataField.initialize();
        unitTeeths=Application.loadResource(Rez.Strings.unitTeeths);
    }

    function onLayout(dc as Dc) as Void {
        System.println("SlavicsGearRearView.onLayout() "+dc.getWidth()+"x"+dc.getHeight());
        SlavicsSimpleDataField.onLayout(dc);
        teethsLabel.locX=self.rim;
        teethsLabel.locY=self.labelLine;
    }
    /***/
    function onShow() {
        System.println("SlavicsGearRearView.onShow()");
        SlavicsSimpleDataField.onShow();
        self.setTextLabel(Application.loadResource(Rez.Strings.label));
    }
    /***/
    (:release)
    function compute(info as Activity.Info) as Void {
        SlavicsSimpleDataField.compute(info);
        var bsds=bikeShift.getDeviceState() as AntPlus.DeviceState;
        if(bsds!=null&&bsds.state!=null){
            switch(bsds.state){
                case AntPlus.DEVICE_STATE_SEARCHING:
                    self.setTextLabel(System.getClockTime().sec%2==0?"."+self.textLabel+".":".."+self.textLabel+"..");
                    break;
                case AntPlus.DEVICE_STATE_TRACKING:
                    self.setTextLabel(self.textLabel);
                    break;
                default:
                    self.setTextLabel("?"+self.textLabel+"?");
            }
        }

        var ss=bikeShift.getShiftingStatus() as AntPlus.ShiftingStatus;
        if(ss!=null){
                if(ss.rearDerailleur.gearIndex!=AntPlus.REAR_GEAR_INVALID){    
                    setTextValue((ss.rearDerailleur.gearIndex+1).toString());
                    teethsLabel.setText(ss.rearDerailleur.gearSize+unitTeeths);
                } else {
                    setTextValue("Inv.");
                    teethsLabel.setText("--"+unitTeeths);
                }
        } else {
            teethsLabel.setText("--");
            setTextValue("--");
        }
    }

    (:debug)
    function compute(info as Activity.Info) as Void {
        SlavicsSimpleDataField.compute(info);
        if(System.getClockTime().sec/15%2==0){
            System.println("SlavicsGearRearView.compute(info)");
            self.setTextValue(info.currentSpeed!=null?(info.currentSpeed*3.6f).format("%0.1f")+"km/h":"--km/h");
            teethsLabel.setText("--");
        } else {
            System.println("SlavicsGearRearView.compute(debug)");
            self.setTextValue((System.getClockTime().sec/3f).format("%0.1f")+"d");
            teethsLabel.setText(Math.rand()%51+unitTeeths);
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    
    public function onUpdate(dc as Dc) as Void {
        System.println("SlavicsGearRearView.onUpdate()");
        SlavicsSimpleDataField.onUpdate(dc);
        teethsLabel.draw(dc);
    }
}
