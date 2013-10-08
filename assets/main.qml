import bb.cascades 1.0

TabbedPane
{
    id: root
    property string lastSavedFile
    property string body
    activeTab: defaultTab
    
    onLastSavedFileChanged: {
        activeTab.content.lastSavedFile = lastSavedFile;
    }
    
    onBodyChanged: {
        activeTab.content.body = body;
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: definition
        },
        
        ComponentDefinition
        {
            id: newDefinition
            
            Tab {
                title: qsTr("Doc %1").arg( root.count() )
                description: qsTr("Untitled") + Retranslate.onLanguageChanged
                imageSource: "images/ic_doc.png"
                
                DocumentPage {}
            }
        }
    ]
    
    Menu.definition: CanadaIncMenu {
        projectName: "notepad-plus"
        
        onCreationCompleted: {
            addAction(donateAction);
        }
        
        attachedObjects: [
            ActionItem {
                id: donateAction
                title: qsTr("Donate") + Retranslate.onLanguageChanged
                imageSource: "images/ic_donate.png"
                
                onTriggered: {
                    donator.trigger("bb.action.OPEN");
                }
                
                attachedObjects: [
                    Invocation {
                        id: donator
                        
                        query {
                            mimeType: "text/html"
                            uri: "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=admin@canadainc.org&currency_code=CAD&no_shipping=1&tax=0&lc=CA&bn=PP-DonationsBF&item_name=Support NotepadPlus Development"
                        }
                    }
                ]
            }
        ]
    }
    
    Tab {
        id: newTab
        title: qsTr("New") + Retranslate.onLanguageChanged
        description: qsTr("New Document") + Retranslate.onLanguageChanged
        imageSource: "images/ic_new_doc.png"
        
        onTriggered: {
            var newDoc = newDefinition.createObject();
            root.add(newDoc);
            
            root.activeTab = newDoc;
            newDoc.triggered();
        }
    }
    
    Tab
    {
        id: defaultTab
        title: qsTr("Default") + Retranslate.onLanguageChanged
        description: qsTr("Default Document") + Retranslate.onLanguageChanged
        imageSource: "images/ic_doc.png"
        
        DocumentPage {}
    }
}