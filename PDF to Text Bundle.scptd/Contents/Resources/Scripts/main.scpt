JsOsaDAS1.001.00bplist00�Vscript_var SystemEvents = Application("System Events")
var fileTypesToProcess = ["PDF"]
var extensionsToProcess = ["pdf"]
var typeIdentifiersToProcess = ["com.adobe.pdf"]
 
function openDocuments(droppedItems) {
    for (var item of droppedItems) {
        var alias = SystemEvents.aliases.byName(item.toString())
        var extension = alias.nameExtension()
        var fileType = alias.fileType()
        var typeIdentifier = alias.typeIdentifier()
            if (fileTypesToProcess.includes(fileType) || extensionsToProcess.includes(extension) || typeIdentifiersToProcess.includes(typeIdentifier)) {
            processItem(item)
        }
    }
}
 
function processItem(item) {
	alert(item)
    // NOTE: The variable item is an instance of the Path object
    // Add item processing code here
}
                              0jscr  ��ޭ