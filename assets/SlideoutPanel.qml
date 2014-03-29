import bb.cascades 1.0

Container
{
    id: root
    signal clicked(string targetId)
    preferredHeight: 619
    translationY: -600
    
    function slideIn()
    {
        sliderAnim.fromY = -600;
        sliderAnim.toY = 0;
        sliderAnim.play();
    }
    
    function slideOut()
    {
        sliderAnim.fromY = 0;
        sliderAnim.toY = -600;
        sliderAnim.play();
    }

    Container
    {
        layout: DockLayout {}
        
        ImageView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            imageSource: "images/slideout/slideout_background.png"
        }
        
        Container
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            leftPadding: 20; rightPadding: 20; bottomPadding: 20
            
            ListView
            {
                horizontalAlignment: HorizontalAlignment.Fill
                
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                
                dataModel: ArrayDataModel {
                    id: adm
                }
                
                onCreationCompleted: {
                    adm.append({'title': "BBM", 'value': "sys.bbm.sharehandler", 'imageSource': "file:///usr/share/icons/ic_start_bbm_chat.png"});
                    adm.append({'title': "BBM Group", 'value': "sys.bbgroups.sharehandler", 'imageSource': "file:///usr/share/icons/ic_invite_to_bbm_group.png"});
                    adm.append({'title': "Email", 'value': "sys.pim.uib.email.hybridcomposer", 'imageSource': "images/slideout/ic_email.png"});
                    adm.append({'title': "Remember", 'value': "sys.pim.remember.composer", 'imageSource': "images/slideout/ic_remember.png"});
                    adm.append({'title': "SMS", 'value': "bbm", 'imageSource': "images/slideout/ic_sms.png"});
                }
                
                listItemComponents: ListItemComponent
                {
                    StandardListItem
                    {
                        description: ListItemData.title
                        imageSource: ListItemData.imageSource
                    }
                }
                
                onTriggered: {
                    var data = dataModel.data(indexPath);
                    clicked(data.value);
                }
            }
            
            Label
            {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Center
                
                text: qsTr("Share") + Retranslate.onLanguageChanged
                
                textStyle {
                    base: SystemDefaults.TextStyles.BigText
                    color: Color.White
                    textAlign: TextAlign.Center
                }
                
                onTouch: {
                    if ( event.isDown() )
                    {
                        if (translationY == 0) {
                            slideOut();
                        } else {
                            slideIn();
                        }
                    }
                }
            }
        }
    }
    
    ImageView
    {
        horizontalAlignment: HorizontalAlignment.Fill
        imageSource: "images/slideout/shadow.png"
        translationY: -7
    }
    
    animations: [
        TranslateTransition {
            id: sliderAnim
            fromY: 0
            toY: -600
            easingCurve: StockCurve.BackInOut
            duration: 800
        }
    ]
}