import bb 1.0
import bb.cascades 1.0
import bb.cascades.pickers 1.0

NavigationPane
{
    id: navigationPane

    attachedObjects: [
        ComponentDefinition {
            id: definition
        }
    ]
    
    Menu.definition: CanadaIncMenu {
        projectName: "message-templates"
    }

    onPopTransitionEnded: {
        page.destroy();
    }
    
    Page
    {
        id: rootPage
        actionBarVisibility: ChromeVisibility.Hidden
        
        actions: [
            ActionItem {
                title: qsTr("Save As") + Retranslate.onLanguageChanged
                imageSource: "images/ic_save.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: {
                    filePicker.open();
                }
                
                attachedObjects: [
                    FilePicker {
                        id: filePicker
                        mode: FilePickerMode.Saver
                        title: qsTr("Specify File Name") + Retranslate.onLanguageChanged
                        type: FileType.Document
                        filter: [ "*.txt" ]
                        defaultSaveFileNames: ["New.txt"]
                        allowOverwrite: true
                        
                        onFileSelected: {
                            var result = selectedFiles[0]
                            var written = app.save(result, textArea.text);
                            
                            if (written) {
                                persist.showToast( qsTr("Successfully written file: %1").arg(result) );
                            } else {
                                persist.showToast( qsTr("Could not write file: %1\n\nDid you make sure you gave the app the Shared Files permission? This permission is needed for the app to access your shared folder to write the file.\n\nIf you disabled it by mistake, go to BB10 Settings -> Security & Privacy -> Application Permissions -> Notepad Plus and enable it.").arg(result), qsTr("OK") );
                            }
                        }
                    }
                ]
            },
            
            DeleteActionItem {
                id: clearAction
                title: qsTr("Clear") + Retranslate.onLanguageChanged
                imageSource: "images/ic_delete.png"
                
                onTriggered: {
                    textArea.resetText();
                    textArea.requestFocus();
                }
            }
        ]
        
        TextArea {
            id: textArea

            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            backgroundVisible: false
            hintText: qsTr("Start typing here...") + Retranslate.onLanguageChanged
            
            onCreationCompleted: {
                Application.aboutToQuit.connect(onAboutToQuit);
                Application.sceneChanged.connect(requestFocus);
                text = persist.getValueFor("data");
            }
            
            onFocusedChanged: {
                if (focused) {
                    rootPage.actionBarVisibility = ChromeVisibility.Hidden;
                }
            }
            
            function onAboutToQuit() {
                persist.saveValueFor("data", text);
            }
            
            attachedObjects: [
                UIToolkitSupport {
                    id: uis
                    
                    onSwipedDown: {
                        rootPage.actionBarVisibility = ChromeVisibility.Overlay;
                    }
                }
            ]
        }
    }
}