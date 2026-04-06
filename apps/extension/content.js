// Listen for fill messages from the popup
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'fill') {
    const filled = fillLoginForm(message.username, message.password);
    sendResponse({ filled });
  }
  return true;
});

function fillLoginForm(username, password) {
  // Find password field
  const passwordField = findPasswordField();
  if (!passwordField) return false;

  // Find username field (usually the input before the password field)
  const usernameField = username ? findUsernameField(passwordField) : null;

  // Fill fields
  if (usernameField && username) {
    setInputValue(usernameField, username);
  }

  if (password) {
    setInputValue(passwordField, password);
  }

  return true;
}

function findPasswordField() {
  // Direct password inputs
  const passwordInputs = document.querySelectorAll('input[type="password"]');
  if (passwordInputs.length > 0) {
    // Return the first visible one
    for (const input of passwordInputs) {
      if (isVisible(input)) return input;
    }
  }
  return null;
}

function findUsernameField(passwordField) {
  // Strategy 1: Find by common attributes
  const selectors = [
    'input[type="email"]',
    'input[type="text"][name*="user"]',
    'input[type="text"][name*="email"]',
    'input[type="text"][name*="login"]',
    'input[type="text"][autocomplete="username"]',
    'input[type="text"][autocomplete="email"]',
    'input[type="email"][autocomplete="username"]',
  ];

  for (const selector of selectors) {
    const fields = document.querySelectorAll(selector);
    for (const field of fields) {
      if (isVisible(field)) return field;
    }
  }

  // Strategy 2: Find the closest text/email input before the password field
  const allInputs = Array.from(document.querySelectorAll('input[type="text"], input[type="email"], input:not([type])'));
  const visibleInputs = allInputs.filter(isVisible);

  // Find the one closest to and before the password field in DOM order
  let closest = null;
  for (const input of visibleInputs) {
    if (input.compareDocumentPosition(passwordField) & Node.DOCUMENT_POSITION_FOLLOWING) {
      closest = input;
    }
  }

  return closest;
}

function setInputValue(input, value) {
  // Focus the input
  input.focus();

  // Set value using multiple methods for framework compatibility
  const nativeInputValueSetter = Object.getOwnPropertyDescriptor(
    window.HTMLInputElement.prototype, 'value'
  ).set;

  nativeInputValueSetter.call(input, value);

  // Dispatch events that frameworks listen for
  input.dispatchEvent(new Event('input', { bubbles: true }));
  input.dispatchEvent(new Event('change', { bubbles: true }));
  input.dispatchEvent(new KeyboardEvent('keydown', { bubbles: true }));
  input.dispatchEvent(new KeyboardEvent('keyup', { bubbles: true }));
}

function isVisible(element) {
  const style = window.getComputedStyle(element);
  return (
    style.display !== 'none' &&
    style.visibility !== 'hidden' &&
    style.opacity !== '0' &&
    element.offsetWidth > 0 &&
    element.offsetHeight > 0
  );
}
