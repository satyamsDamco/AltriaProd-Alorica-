({
    RETRY_DELAY_MS: 300,

    /*
     * Omni-Channel opens the work item's primary tab natively, but the
     * omniChannelWorkAccepted event usually fires before that tab exists.
     * Poll getAllTabInfo for the native tab; only fall back to openTab
     * (which the console dedupes by recordId) if it never appears.
     */
    findPrimaryTab: function(cmp, recordId, retriesLeft) {
        var self = this;
        var workspace = cmp.find('workspace');

        return workspace.getAllTabInfo().then(function(tabs) {
            var match = (tabs || []).filter(function(tab) {
                return !tab.isSubtab && tab.recordId === recordId;
            })[0];

            if (match) {
                return match.tabId;
            }

            if (retriesLeft <= 0) {
                return workspace.openTab({ recordId: recordId, focus: true });
            }

            return new Promise(function(resolve) {
                window.setTimeout($A.getCallback(function() {
                    resolve(self.findPrimaryTab(cmp, recordId, retriesLeft - 1));
                }), self.RETRY_DELAY_MS);
            });
        });
    },

    openConsumerSearchSubtab: function(cmp, parentTabId, workItemId) {
        var workspace = cmp.find('workspace');
        var subtabUrl = '/apex/ChatConsumerSearch?chatId=' + encodeURIComponent(workItemId);

        return workspace.getTabInfo({ tabId: parentTabId })
            .then(function(tabInfo) {
                // Guard against duplicate event fires: focus the existing subtab instead
                var existing = ((tabInfo && tabInfo.subtabs) || []).filter(function(sub) {
                    return sub.url && sub.url.indexOf('/apex/ChatConsumerSearch') !== -1;
                })[0];

                if (existing) {
                    return workspace.focusTab({ tabId: existing.tabId }).then(function() {
                        return existing.tabId;
                    });
                }

                return workspace.openSubtab({
                    parentTabId: parentTabId,
                    url: subtabUrl,
                    focus: true
                });
            })
            .then(function(subtabId) {
                return Promise.all([
                    workspace.setTabLabel({ tabId: subtabId, label: 'Consumer Search' }),
                    workspace.setTabIcon({ tabId: subtabId, icon: 'standard:search', iconAlt: 'Consumer Search' })
                ]).then(function() {
                    return subtabId;
                });
            });
    }
})