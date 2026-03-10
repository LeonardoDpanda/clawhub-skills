// Popup script
const OPENCLAW_PORT = 5003;
const OPENCLAW_HOST = '127.0.0.1';

document.addEventListener('DOMContentLoaded', async () => {
  const statusDiv = document.getElementById('status');
  const toggleBtn = document.getElementById('toggleBtn');
  
  // Get current tab
  const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
  
  // Check if already connected
  async function updateStatus() {
    try {
      const response = await fetch(`http://${OPENCLAW_HOST}:${OPENCLAW_PORT}/status`);
      const data = await response.json();
      
      if (data.connected && data.tabId === tab.id) {
        statusDiv.textContent = 'Status: Connected ✅';
        statusDiv.className = 'status connected';
        toggleBtn.textContent = 'Detach This Tab';
        toggleBtn.className = 'disconnect';
      } else {
        statusDiv.textContent = 'Status: Disconnected';
        statusDiv.className = 'status disconnected';
        toggleBtn.textContent = 'Attach This Tab';
        toggleBtn.className = 'connect';
      }
    } catch (e) {
      statusDiv.textContent = 'Status: OpenClaw Not Running';
      statusDiv.className = 'status disconnected';
      toggleBtn.disabled = true;
    }
  }
  
  // Toggle connection
  toggleBtn.addEventListener('click', async () => {
    if (toggleBtn.textContent === 'Attach This Tab') {
      try {
        const response = await fetch(`http://${OPENCLAW_HOST}:${OPENCLAW_PORT}/attach`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ 
            tabId: tab.id,
            url: tab.url,
            title: tab.title
          })
        });
        
        if (response.ok) {
          await updateStatus();
          window.close();
        } else {
          statusDiv.textContent = 'Status: Failed to connect';
        }
      } catch (e) {
        statusDiv.textContent = 'Status: OpenClaw not running';
      }
    } else {
      // Detach
      try {
        await fetch(`http://${OPENCLAW_HOST}:${OPENCLAW_PORT}/detach`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ tabId: tab.id })
        });
        await updateStatus();
      } catch (e) {
        console.error('Detach failed:', e);
      }
    }
  });
  
  // Initial status check
  await updateStatus();
});
