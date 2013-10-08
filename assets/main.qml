import bb 1.0
import bb.cascades 1.0
import bb.cascades.pickers 1.0
import bb.system 1.0

NavigationPane
{
    id: navigationPane
    property alias lastSavedFile: filePicker.lastPath
    property alias body: textArea.text

    attachedObjects: [
        ComponentDefinition {
            id: definition
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
                
                shortcuts: [
                    SystemShortcut {
                        type: SystemShortcuts.Search
                    }
                ]
                
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
                
                shortcuts: [
                    Shortcut {
                        key: qsTr("A") + Retranslate.onLanguageChanged
                    }
                ]
                
                onTriggered: {
                    filePicker.open();
                }
                
                attachedObjects: [
                    FilePicker {
                        id: filePicker
                        property string lastPath: persist.getValueFor("lastFile")
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
                id: openAction
                title: qsTr("Open") + Retranslate.onLanguageChanged
                imageSource: "images/ic_open.png"
                
                onTriggered: {
                    fileOpener.directories = [persist.getValueFor("input"), "/accounts/1000/shared/documents"];
                    fileOpener.open();
                }
                
                shortcuts: [
                    Shortcut {
                        key: qsTr("O") + Retranslate.onLanguageChanged
                    }
                ]
                
                attachedObjects: [
                    FilePicker {
                        id: fileOpener
                        mode: FilePickerMode.Picker
                        title: qsTr("Choose File") + Retranslate.onLanguageChanged
                        type: FileType.Other
                        
                        onFileSelected: {
                            var lastFile = selectedFiles[selectedFiles.length - 1];
                            var lastDir = lastFile.substring(0, lastFile.lastIndexOf("/") + 1);
                            persist.saveValueFor("input", lastDir);

                            app.open(selectedFiles[0]);
                        }
                    }
                ]
            },
            
            ActionItem {
                id: copyAllAction
                title: qsTr("Copy") + Retranslate.onLanguageChanged
                imageSource: "images/ic_copy_all.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                shortcuts: [
                    SystemShortcut {
                        type: SystemShortcuts.CreateNew
                    }
                ]
                
                onTriggered: {
                    persist.copyToClipboard(textArea.text);
                }
            },
            
            DeleteActionItem {
                id: clearAction
                title: qsTr("Clear") + Retranslate.onLanguageChanged
                imageSource: "images/ic_delete.png"
                
                onTriggered: {
                    prompt.show()
                }
                
                attachedObjects: [
                    SystemDialog {
                        id: prompt
                        title: qsTr("Confirm") + Retranslate.onLanguageChanged
                        body: qsTr("Are you sure you want to clear the text?") + Retranslate.onLanguageChanged
                        confirmButton.label: qsTr("Yes") + Retranslate.onLanguageChanged
                        cancelButton.label: qsTr("No") + Retranslate.onLanguageChanged

                        onFinished: {
                            if (result == SystemUiResult.ConfirmButtonSelection)
                            {
                                persist.remove("lastFile");
                                lastSavedFile = "";
                                textArea.resetText();
                                textArea.requestFocus();
                            }
                        }
                    }
                ]
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
                    if ( persist.getValueFor("loadCache") == 1 ) {
                        persist.saveValueFor("data", textArea.text);
                        persist.saveValueFor("lastFile", filePicker.lastPath);
                    }
                });
                
                Application.sceneChanged.connect(requestFocus);
                
                if ( persist.getValueFor("loadCache") == 1 ) {
                    text = persist.getValueFor("data");
                }
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
                        rootPage.actionBarVisibility = ChromeVisibility.Overlay;
                    }
                }
            ]
        }
    }
}