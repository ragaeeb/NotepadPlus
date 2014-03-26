import bb.cascades 1.0
import bb 1.0

Page
{
    attachedObjects: [
        ApplicationInfo {
            id: appInfo
        },

        PackageInfo {
            id: packageInfo
        }
    ]
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    
    actions: [
        InvokeActionItem
        {
            title: qsTr("Our BBM Channel") + Retranslate.onLanguageChanged
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "images/menu/ic_channel.png"
            
            query {
                invokeTargetId: "sys.bbm.channels.card.previewer"
                uri: "bbmc:C0034D28B"
            }
        },
        
        InvokeActionItem
        {
            imageSource: "images/menu/ic_video_tutorial.png"
            title: qsTr("Video Tutorial") + Retranslate.onLanguageChanged
            ActionBar.placement: ActionBarPlacement.OnBar
            
            query {
                mimeType: "text/html"
                uri: "http://www.youtube.com/watch?v=AbHZLmWSKts"
                invokeActionId: "bb.action.OPEN"
            }
        }
    ]
    
    titleBar: TitleBar {
        title: qsTr("Help") + Retranslate.onLanguageChanged
    }

    Container
    {
        leftPadding: 20; rightPadding: 20;

        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        ScrollView
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            Label {
                multiline: true
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                textStyle.textAlign: TextAlign.Center
                textStyle.fontSize: FontSize.Small
                content.flags: TextContentFlag.ActiveText | TextContentFlag.EmoticonsOff
                text: qsTr("\n\n(c) 2014 %1. All Rights Reserved.\n%2 %3\n\nPlease report all bugs to:\nsupport@canadainc.org\n\nA simple lightweight notepad app for BB10. The idea was to make the startup time almost instant while maximizing usefulness.\n\nNote that this app requires the 'Shared Files' permission to be able to save the document into your chosen folder.").arg(packageInfo.author).arg(appInfo.title).arg(appInfo.version)
            }
        }
    }
}
