import bb.cascades 1.0

Page
{
    titleBar: TitleBar {
        title: qsTr("Settings") + Retranslate.onLanguageChanged
    }
    
    Container
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        leftPadding: 20
        topPadding: 20
        rightPadding: 20
        bottomPadding: 20
        
        SettingPair
        {
            title: qsTr("Load Cache");
            key: "loadCache"
        }
        
        PersistDropDown
        {
            topMargin: 20
            key: "theme"
            title: qsTr("Visual Style") + Retranslate.onLanguageChanged
            
            Option {
                text: qsTr("Bright") + Retranslate.onLanguageChanged
                description: qsTr("Black text on a white background.") + Retranslate.onLanguageChanged
                imageSource: "images/ic_theme_bright.png"
                value: "bright"
            }
            
            Option {
                text: qsTr("Dark") + Retranslate.onLanguageChanged
                description: qsTr("White text on a black background.") + Retranslate.onLanguageChanged
                imageSource: "images/ic_theme_dark.png"
                value: "dark"
            }
            
            onValueChanged: {
                if (diff)
                {
                    var changed = app.changeTheme(selectedOption.value);
                    
                    if (changed) {
                        persist.showToast( qsTr("%1 theme applied, please restart the app.").arg(selectedOption.text) );
                    }
                }
            }
        }
    }
}