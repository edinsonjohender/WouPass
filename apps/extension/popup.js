const fillBtn = document.getElementById('fill-btn');
const resultDiv = document.getElementById('result');
const resultTitle = document.getElementById('result-title');
const resultUser = document.getElementById('result-user');
const resultMsg = document.getElementById('result-msg');

fillBtn.addEventListener('click', async () => {
  try {
    // Read clipboard
    const text = await navigator.clipboard.readText();

    if (!text) {
      showError('Clipboard is empty. Send a password from your phone first.');
      return;
    }

    // Try to parse as WouPass credential JSON
    let credential;
    try {
      credential = JSON.parse(text);
      if (!credential.password) throw new Error('Not a WouPass credential');
    } catch {
      // Not JSON - treat as plain password
      credential = { password: text, username: '', title: 'Clipboard' };
    }

    // Send to content script to fill the form
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

    chrome.tabs.sendMessage(tab.id, {
      action: 'fill',
      username: credential.username || '',
      password: credential.password || '',
    }, (response) => {
      if (response && response.filled) {
        resultTitle.textContent = credential.title || 'Credential';
        resultUser.textContent = credential.username ? `User: ${credential.username}` : '';
        resultMsg.textContent = '✓ Form filled successfully';
        resultMsg.style.color = '#3ECF8E';
        resultDiv.classList.add('show');
        fillBtn.textContent = 'Filled!';
        fillBtn.disabled = true;

        // Clear clipboard after fill
        navigator.clipboard.writeText('').catch(() => {});

        setTimeout(() => {
          fillBtn.textContent = 'Fill from clipboard';
          fillBtn.disabled = false;
        }, 3000);
      } else {
        showError('No login form found on this page.');
      }
    });
  } catch (e) {
    showError('Cannot read clipboard. Make sure you allowed clipboard access.');
  }
});

function showError(msg) {
  resultTitle.textContent = 'Error';
  resultUser.textContent = '';
  resultMsg.textContent = msg;
  resultMsg.style.color = '#EF4444';
  resultDiv.classList.add('show');
}
