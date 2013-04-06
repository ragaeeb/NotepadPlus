import bb.cascades 1.0

NavigationPane
{
    id: navigationPane

    attachedObjects: [
        ComponentDefinition {
            id: definition
        }
    ]

    Menu.definition: MenuDefinition
    {
        helpAction: HelpActionItem
        {
            property Page helpPage
            
            onTriggered:
            {
                if (!helpPage) {
                    definition.source = "HelpPage.qml"
                    helpPage = definition.createObject();
                }

                navigationPane.push(helpPage);
            }
        }
        
        actions: [
            ActionItem {
                id: clearAction
                title: qsTr("Clear") + Retranslate.onLanguageChanged
                
                onTriggered: {
                    textArea.resetText()
                }
            }
        ]
    }

    onPopTransitionEnded: {
        page.destroy();
    }
    
    Page
    {
        id: page
        
        TextArea {
            property variant appScene: Application.scene
            
            id: textArea
            objectName: "textArea"
            
            onAppSceneChanged: {
                requestFocus()
            }
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            backgroundVisible: false
            hintText: qsTr("Start typing here...") + Retranslate.onLanguageChanged
        }
    }
}