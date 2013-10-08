import bb.cascades 1.0

Page
{
    titleBar: TitleBar {
        title: qsTr("Settings") + Retranslate.onLanguageChanged
    }
    
    ScrollView
    {  
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
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
                    if (diff) {
                        persist.showToast( qsTr("%1 theme applied, please restart the app.").arg(selectedOption.text) );
                    }
                }
            }
            
            PersistDropDown
            {
                topMargin: 20
                key: "fontSize"
                title: qsTr("Font Size") + Retranslate.onLanguageChanged
                
                Option {
                    text: qsTr("Default") + Retranslate.onLanguageChanged
                    description: qsTr("Default font size.") + Retranslate.onLanguageChanged
                    imageSource: "images/ic_font_default.png"
                    value: FontSize.Default
                }
                
                Option {
                    text: qsTr("Smallest") + Retranslate.onLanguageChanged
                    description: qsTr("Smallest font size.") + Retranslate.onLanguageChanged
                    imageSource: "images/ic_font_small.png"
                    value: FontSize.XXSmall
                }
                
                Option {
                    text: qsTr("Small") + Retranslate.onLanguageChanged
                    description: qsTr("Small font size.") + Retranslate.onLanguageChanged
                    imageSource: "images/ic_font_small.png"
                    value: FontSize.Small
                }
                
                Option {
                    text: qsTr("Medium") + Retranslate.onLanguageChanged
                    description: qsTr("Medium font size.") + Retranslate.onLanguageChanged
                    imageSource: "images/ic_font.png"
                    value: FontSize.Medium
                }
                
                Option {
                    text: qsTr("Large") + Retranslate.onLanguageChanged
                    description: qsTr("Large font size.") + Retranslate.onLanguageChanged
                    imageSource: "images/ic_font_large.png"
                    value: FontSize.Large
                }
                
                Option {
                    text: qsTr("Largest") + Retranslate.onLanguageChanged
                    description: qsTr("Largest font size.") + Retranslate.onLanguageChanged
                    imageSource: "images/ic_font_large.png"
                    value: FontSize.XXLarge
                }
            }
        }
    }
}