import bb 1.0
import bb.cascades 1.0

TextArea
{
    id: textArea
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    backgroundVisible: false
    hintText: qsTr("Start typing here...") + Retranslate.onLanguageChanged
    textStyle.fontSizeValue: persist.contains("fontSizeValue") ? persist.getValueFor("fontSizeValue") : 8
    textStyle.fontSize: FontSize.PointValue
    content.flags: focused ? TextContentFlag.ActiveTextOff | TextContentFlag.EmoticonsOff : TextContentFlag.ActiveText | TextContentFlag.Emoticons
    
    gestureHandlers: [
        PinchHandler {
            onPinchEnded: {
                var newValue = Math.floor(event.pinchRatio*textStyle.fontSizeValue);
                newValue = Math.max(4,newValue);
                newValue = Math.min(newValue, 20);
                
                textStyle.fontSizeValue = newValue;
                persist.saveValueFor("fontSizeValue", newValue);
            }
            
            onPinchUpdated: {
                var newValue = Math.floor(event.pinchRatio*textStyle.fontSizeValue);
                newValue = Math.max(4,newValue);
                newValue = Math.min(newValue, 20);
                
                textStyle.fontSizeValue = newValue;
            }
        }
    ]
    
    onCreationCompleted: {
        Application.sceneChanged.connect(requestFocus);
    }
    
    onFocusedChanged: {
        if (focused) {
            rootPage.actionBarVisibility = ChromeVisibility.Hidden;
        }
    }
    
    attachedObjects: [
        UIToolkitSupport {
            id: uis
            
            onSwipedDown: {
                textArea.loseFocus();
                rootPage.actionBarVisibility = ChromeVisibility.Visible;
            }
        }
    ]
}