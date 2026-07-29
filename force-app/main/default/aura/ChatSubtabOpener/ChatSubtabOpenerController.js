({
    onWorkAccepted: function(cmp, evt, helper) {
        var workItemId = evt.getParam('workItemId') || '';
        var prefix = workItemId.substring(0, 3);

        // 570 = LiveChatTranscript (legacy Live Agent), 0Mw = MessagingSession (Enhanced Messaging)
        if (prefix !== '570' && prefix !== '0Mw') {
            return;
        }

        helper.findPrimaryTab(cmp, workItemId, 10)
            .then(function(parentTabId) {
                return helper.openConsumerSearchSubtab(cmp, parentTabId, workItemId);
            })
            .catch(function(error) {
                console.error('ChatSubtabOpener: error opening Consumer Search subtab', error);
            });
    }
})