import bb.cascades 1.2

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
    
    onCreationCompleted: {
        Application.aboutToQuit.connect( function onAboutToQuit() {
            if ( root.count() == 2 && persist.getValueFor("loadCache") == 1 ) {
                persist.saveValueFor("data", activeTab.content.body);
                persist.saveValueFor("lastFile", activeTab.content.lastSavedFile);
            }
        });
    }
    
    Menu.definition: CanadaIncMenu
    {
        projectName: "notepad-plus"
        allowDonations: true
        help.imageSource: "images/menu/ic_help.png"
        help.title: qsTr("Help") + Retranslate.onLanguageChanged
        settings.imageSource: "images/menu/ic_settings.png"
        settings.title: qsTr("Settings") + Retranslate.onLanguageChanged
    }
    
    Tab {
        id: newTab
        title: qsTr("New") + Retranslate.onLanguageChanged
        description: qsTr("New Document") + Retranslate.onLanguageChanged
        imageSource: "images/tabs/ic_new_doc.png"
        
        onTriggered: {
            var newDoc = newDefinition.createObject();
            root.add(newDoc);
            
            root.activeTab = newDoc;
            newDoc.triggered();
        }
        
        attachedObjects: [
            ComponentDefinition
            {
                id: newDefinition
                
                Tab {
                    title: qsTr("Doc %1").arg( root.count() )
                    description: qsTr("Untitled") + Retranslate.onLanguageChanged
                    imageSource: "images/tabs/ic_doc.png"
                    
                    DocumentPage {}
                }
            }
        ]
    }
    
    Tab
    {
        id: defaultTab
        title: qsTr("Default") + Retranslate.onLanguageChanged
        description: qsTr("Default Document") + Retranslate.onLanguageChanged
        imageSource: "images/tabs/ic_doc.png"
        delegateActivationPolicy: TabDelegateActivationPolicy.ActivateWhenSelected
        
        delegate: Delegate {
            source: "DocumentPage.qml"
        }
    }
}