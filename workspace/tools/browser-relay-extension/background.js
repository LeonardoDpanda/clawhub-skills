// OpenClaw Browser Relay - Background Script
const OPENCLAW_PORT = 5003;
const OPENCLAW_HOST = '127.0.0.1';

let connectedTabId = null;

// Check connection to OpenClaw
d async function checkOpenClawConnection() {
  try {
    const response = await fetch(`http://${OPENCLAW_HOST}:${OPENCLAW_PORT}/status`, {
      method: 'GET',
      mode: 'cors'
    });
    return response.ok;
  } catch (e) {
    return false;
  }
}

// Connect current tab to OpenClaw
async function connectTab(tabId) {
  try {
    const response = await fetch(`http://${OPENCLAW_HOST}:${OPENCLAW_PORT}/attach`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ tabId: tabId }),
      mode: 'cors'
    });
    
    if (response.ok) {
      connectedTabId = tabId;
      chrome.action.setBadgeText({ text: 'ON' });
      chrome.action.setBadgeBackgroundColor({ color: '#00AA00' });
      return true;
    }
    return false;
  } catch (e) {
    console.error('Failed to connect:', e);
    return false;
  }
}

// Disconnect tab
async function disconnectTab() {
  connectedTabId = null;
  chrome.action.setBadgeText({ text: '' });
}

// Handle extension icon click
chrome.action.onClicked.addListener(async (tab) => {
  if (connectedTabId === tab.id) {
    await disconnectTab();
  } else {
    const connected = await connectTab(tab.id);
    if (!connected) {
      chrome.action.setBadgeText({ text: 'ERR' });
      chrome.action.setBadgeBackgroundColor({ color: '#FF0000' });
    }
  }
});

// Check status periodically
setInterval(async () => {
  const isConnected = await checkOpenClawConnection();
  if (!isConnected && connectedTabId) {
    await disconnectTab();
  }
}, 5000);
