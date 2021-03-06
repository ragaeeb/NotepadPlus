import bb.cascades 1.0
import bb.cascades.pickers 1.0
import bb.system 1.0

NavigationPane
{
    id: navigationPane
    property alias lastSavedFile: filePicker.lastPath
    property alias body: textArea.text
    
    onPopTransitionEnded: {
        page.destroy();
    }
    
    Page
    {
        id: rootPage
        actionBarVisibility: ChromeVisibility.Hidden

        actions: [
            ActionItem
            {
                id: openAction
                title: qsTr("Open") + Retranslate.onLanguageChanged
                imageSource: "images/menu/ic_open.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
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
                            
                            app.open(selectedFiles);
                        }
                    }
                ]
            },
            
            ActionItem {
                id: saveAction
                title: qsTr("Save") + Retranslate.onLanguageChanged
                imageSource: "images/menu/ic_save_existing.png"
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
                imageSource: "images/menu/ic_save.png"
                ActionBar.placement: ActionBarPlacement.OnBar

                shortcuts: [
                    Shortcut {
                        key: qsTr("A") + Retranslate.onLanguageChanged
                    }
                ]

                onTriggered: {
                    if (lastSavedFile.length > 0) {
                        filePicker.defaultSaveFileNames = [ filePicker.getTitle() ];
                    } else {
                        filePicker.defaultSaveFileNames = [ Qt.formatDateTime( new Date(), "MMM-d-yy hh-mm")+".txt" ];
                    }
                    
                    filePicker.open();
                }
                
                attachedObjects: [
                    FilePicker {
                        id: filePicker
                        property string lastPath
                        mode: FilePickerMode.Saver
                        title: qsTr("Specify File Name") + Retranslate.onLanguageChanged
                        type: FileType.Document
                        filter: ["*.txt"]
                        allowOverwrite: true

                        function getTitle() {
                            return lastPath.substring( lastPath.lastIndexOf("/")+1 );
                        }

                        onLastPathChanged: {
                            if (lastPath.length > 0) {
                                navigationPane.parent.title = getTitle();
                            } else {
                                navigationPane.parent.title = qsTr("Untitled");
                            }
                        }

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
                imageSource: "images/menu/ic_copy_all.png"
                
                shortcuts: [
                    SystemShortcut {
                        type: SystemShortcuts.CreateNew
                    }
                ]
                
                onTriggered: {
                    persist.copyToClipboard(textArea.text);
                }
            },

            InvokeActionItem
            {
                id: shareTextAction
                title: qsTr("Share As Text") + Retranslate.onLanguageChanged
                
                query {
                    mimeType: "text/plain"
                    invokeActionId: "bb.action.SHARE"
                }
                
                onTriggered: {
                    data = persist.convertToUtf8(textArea.text);
                }
            },
            
            ActionItem
            {
                id: shareFileAction
                title: qsTr("Share As File") + Retranslate.onLanguageChanged
                imageSource: "images/menu/ic_share_file.png"
                
                onTriggered: {
                    panelDelegate.slideInPanel();
                }
            },

            ActionItem {
                title: qsTr("Top") + Retranslate.onLanguageChanged
                imageSource: "images/menu/ic_up.png"
                
                onTriggered: {
                    textArea.editor.cursorPosition = 0;
                    textArea.requestFocus();
                }
            },

            ActionItem {
                title: qsTr("Bottom") + Retranslate.onLanguageChanged
                imageSource: "images/menu/ic_down.png"
                
                onTriggered: {
                    textArea.editor.cursorPosition = textArea.text.length-1;
                    textArea.requestFocus();
                }
            },
            
            DeleteActionItem
            {
                id: clearAction
                title: qsTr("Clear") + Retranslate.onLanguageChanged
                imageSource: "images/menu/ic_delete.png"

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

        Container
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            layout: DockLayout {}
            
            DocumentBody
            {
                id: textArea
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                onTextChanging: {
                    copyAllAction.enabled = shareTextAction.enabled = text.length > 0;
                }
            }
            
            ControlDelegate
            {
                id: panelDelegate
                delegateActive: false
                
                function slideInPanel()
                {
                    if (!delegateActive) {
                        delegateActive = true;
                    } else {
                        control.slideIn();
                    }
                }
                
                sourceComponent: ComponentDefinition
                {
                    SlideoutPanel
                    {
                        id: panel
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Top
                        
                        onClicked: {
                            if (lastSavedFile.length > 0) {
                                app.share(lastSavedFile, targetId);
                            } else {
                                app.shareLocal(textArea.text, targetId);
                            }
                        }
                        
                        onCreationCompleted: {
                            slideIn();
                        }
                    }
                }
            }
        }
    }
}