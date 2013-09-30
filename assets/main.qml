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
                id: saveAction
                title: qsTr("Save") + Retranslate.onLanguageChanged
                imageSource: "images/ic_save_existing.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                enabled: filePicker.lastPath.length > 0;
                
                onCreationCompleted: {
                    filePicker.lastPathChanged.connect( function() {
                        saveAction.enabled = filePicker.lastPath.length > 0;
                    });
                }
                
                onTriggered: {
                    filePicker.fileSelected([filePicker.lastPath]);
                }
            },
            
            ActionItem {
                id: saveAsAction
                title: qsTr("Save As") + Retranslate.onLanguageChanged
                imageSource: "images/ic_save.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: {
                    filePicker.open();
                }
                
                attachedObjects: [
                    FilePicker {
                        id: filePicker
                        property string lastPath
                        mode: FilePickerMode.Saver
                        title: qsTr("Specify File Name") + Retranslate.onLanguageChanged
                        type: FileType.Document
                        filter: [ "*.txt" ]
                        defaultSaveFileNames: ["New.txt"]
                        allowOverwrite: true
                        
                        onFileSelected: {
                            lastPath = selectedFiles[0];
                            var written = app.save(lastPath, textArea.text);
                            
                            if (written) {
                                persist.showToast( qsTr("Successfully written file: %1").arg(lastPath) );
                            } else {
                                persist.showToast( qsTr("Could not write file: %1\n\nDid you make sure you gave the app the Shared Files permission? This permission is needed for the app to access your shared folder to write the file.\n\nIf you disabled it by mistake, go to BB10 Settings -> Security & Privacy -> Application Permissions -> Notepad Plus and enable it.").arg(lastPath), qsTr("OK") );
                            }
                        }
                    }
                ]
            },
            
            ActionItem {
                id: copyAllAction
                title: qsTr("Copy") + Retranslate.onLanguageChanged
                imageSource: "images/ic_copy_all.png"
                
                onTriggered: {
                    persist.copyToClipboard(textArea.text);
                }
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
                Application.aboutToQuit.connect( function onAboutToQuit() {
                    persist.saveValueFor("data", textArea.text);
                });
                
                Application.sceneChanged.connect(requestFocus);
                text = persist.getValueFor("data");
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
                        rootPage.actionBarVisibility = ChromeVisibility.Overlay;
                    }
                }
            ]
        }
    }
}