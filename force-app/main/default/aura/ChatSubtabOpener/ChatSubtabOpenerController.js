({
    onWorkAccepted: function(cmp, evt) {
        var workItemId = evt.getParam('workItemId');
        // 570 = LiveChatTranscript key prefix; ignore cases or other routed work
        if (!workItemId || workItemId.substring(0, 3) !== '570') {
            return;
        }
        var workspace = cmp.find('workspace');
        // The console pops the transcript tab on accept; openTab resolves to the
        // already-open tab so we can attach the Consumer Search subtab to it
        workspace.openTab({ recordId: workItemId, focus: true })
            .then(function(tabId) {
                return workspace.openSubtab({
                    parentTabId: tabId,
                    url: '/apex/ChatConsumerSearch',
                    focus: true
                });
            })
            .then(function(subtabId) {
                workspace.setTabLabel({ tabId: subtabId, label: 'Consumer Search' });
                workspace.setTabIcon({ tabId: subtabId, icon: 'standard:search', iconAlt: 'Consumer Search' });
            })
            .catch(function(error) {
                console.error('ChatSubtabOpener: failed to open Consumer Search subtab', error);
            });
    }
})
