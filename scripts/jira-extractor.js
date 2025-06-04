// JIRA Task Extractor Script
// Listens for Ctrl+C and extracts JIRA task information to markdown

(function() {
  'use strict';

  // Function to extract text content from rich text elements
  function extractTextFromRichText(element) {
    if (!element) return '';

    const clone = element.cloneNode(true);

    // Convert various elements to markdown
    const paragraphs = clone.querySelectorAll('p');
    paragraphs.forEach(p => {
      const strong = p.querySelector('strong');
      if (strong) {
        strong.outerHTML = `**${strong.textContent}**`;
      }
    });

    const lists = clone.querySelectorAll('ol, ul');
    lists.forEach(list => {
      const items = list.querySelectorAll('li');
      let markdown = '';
      items.forEach((item, index) => {
        const prefix = list.tagName === 'OL' ? `${index + 1}.` : '-';
        markdown += `${prefix} ${item.textContent.trim()}\n`;
      });
      list.outerHTML = markdown;
    });

    // Replace <br> with newlines
    clone.innerHTML = clone.innerHTML.replace(/<br\s*\/?>/gi, '\n');

    return clone.textContent.trim();
  }

  // Function to extract comments
  function extractComments() {
    const commentsContainer = document.querySelector('[data-testid="issue.activity.comments-list"]');
    if (!commentsContainer) return [];

    const comments = [];
    const commentElements = commentsContainer.querySelectorAll('[data-testid*="issue-comment-base.ui.comment.ak-comment"]');
    const processedContents = new Set(); // To prevent duplicates based on content

    commentElements.forEach(commentEl => {
      // Extract author name with multiple fallbacks
      let author = 'Unknown';

      // Try multiple selectors for author name
      const authorSelectors = [
        '[data-testid*="profilecard-trigger"] span[role="presentation"] span',
        '.css-1892tm3', // Based on the HTML structure you provided
        '[data-testid*="profilecard-trigger"] .css-1892tm3',
        'h3 span span', // Another fallback
        '.css-1xariwr .css-pdjbx5 .css-boqt0u span' // More specific selector
      ];

      for (const selector of authorSelectors) {
        const authorElement = commentEl.querySelector(selector);
        if (authorElement && authorElement.textContent.trim() && authorElement.textContent.trim() !== 'Unknown') {
          author = authorElement.textContent.trim();
          break;
        }
      }

      // Skip comments with Unknown authors
      if (author === 'Unknown') {
        return;
      }

      // Extract timestamp
      const timestampElement = commentEl.querySelector('[data-testid="issue-timestamp.relative-time"]');
      let timestamp = '';

      // Try to find absolute date first, fallback to relative date
      const absoluteDateElement = commentEl.querySelector('time') ||
                                  commentEl.querySelector('[datetime]') ||
                                  commentEl.querySelector('.css-9561zd');

      if (absoluteDateElement) {
        timestamp = absoluteDateElement.textContent.trim() ||
                   absoluteDateElement.getAttribute('datetime') ||
                   absoluteDateElement.getAttribute('title') || '';
      } else if (timestampElement) {
        timestamp = timestampElement.textContent.trim();
      }

      // Extract comment content
      const contentElement = commentEl.querySelector('.ak-renderer-document');
      const content = extractTextFromRichText(contentElement);

      if (content && content.trim()) {
        // Use content as the primary key to prevent duplicates
        const contentKey = content.trim();

        if (!processedContents.has(contentKey)) {
          processedContents.add(contentKey);
          comments.push({
            author,
            timestamp,
            content
          });
        }
      }
    });

    return comments;
  }

  // Function to extract attachments
  function extractAttachments() {
    const attachments = [];
    const attachmentElements = document.querySelectorAll('[data-testid="media-title-box"]');

    attachmentElements.forEach(attachmentEl => {
      const nameLeft = attachmentEl.querySelector('[data-testid="truncate-left"]');
      const nameRight = attachmentEl.querySelector('[data-testid="truncate-right"]');
      const footer = attachmentEl.querySelector('[data-testid="title-box-footer"]');

      let filename = '';

      // Try to get filename from truncated parts
      if (nameLeft || nameRight) {
        filename = (nameLeft?.textContent || '') + (nameRight?.textContent || '');
      }

      // If filename is still empty, try alternative selectors
      if (!filename.trim()) {
        const titleHeader = attachmentEl.querySelector('[data-testid="title-box-header"]');
        if (titleHeader) {
          filename = titleHeader.textContent.trim();
        }
      }

      // If still empty, try getting the full title box content
      if (!filename.trim()) {
        // Remove the footer content from the full text
        const footerText = footer?.textContent || '';
        const fullText = attachmentEl.textContent || '';
        filename = fullText.replace(footerText, '').trim();
      }

      const date = footer?.textContent || '';

      if (filename.trim()) {
        attachments.push({ filename: filename.trim(), date });
      }
    });

    return attachments;
  }

  // Function to get current page URL
  function getCurrentTaskUrl() {
    return window.location.href;
  }

  // Function to extract task key from URL or breadcrumb
  function getTaskKey() {
    // Try to get from URL first
    const urlMatch = window.location.href.match(/\/([A-Z]+-\d+)/);
    if (urlMatch) {
      return urlMatch[1];
    }

    // Fallback to breadcrumb
    const linkEl = document.querySelector('[data-testid="issue.views.issue-base.foundation.breadcrumbs.current-issue.item"]');
    return linkEl ? linkEl.textContent.trim() : '';
  }

  // Main function to extract JIRA task data
  function extractJiraTask() {
    try {
      // Extract basic information
      const taskKey = getTaskKey();
      const taskUrl = getCurrentTaskUrl();

      const titleEl = document.querySelector('[data-testid="issue.views.issue-base.foundation.summary.heading"]');
      const title = titleEl ? titleEl.textContent.trim() : '';

      const descEl = document.querySelector('[data-testid="issue.views.field.rich-text.description"]');
      const description = extractTextFromRichText(descEl);

      const comments = extractComments();
      const attachments = extractAttachments();

      // Format as markdown
      let markdown = `### [${taskKey}](${taskUrl}): ${title}\n\n`;

      if (description) {
        markdown += `#### Description\n\n${description}\n\n`;
      }

      if (attachments.length > 0) {
        markdown += `#### Attachments\n\n`;
        attachments.forEach(attachment => {
          markdown += `- **${attachment.filename}** (${attachment.date})\n`;
        });
        markdown += '\n';
      }

      if (comments.length > 0) {
        markdown += `#### Comments\n\n`;
        comments.forEach((comment) => {
          markdown += `<span style="color: #888;">${comment.author}:</span>\n${comment.content}\n\n`;
        });
      }

      return markdown;

    } catch (error) {
      console.error('Error extracting JIRA task:', error);
      return null;
    }
  }

  // Function to copy text to clipboard
  async function copyToClipboard(text) {
    try {
      await navigator.clipboard.writeText(text);
      return true;
    } catch (error) {
      console.error('Failed to copy to clipboard:', error);
      return false;
    }
  }

  // Function to show notification
  function showNotification(message, isSuccess = true) {
    // Create notification element
    const notification = document.createElement('div');
    notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${isSuccess ? '#10B981' : '#EF4444'};
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 10000;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            font-size: 14px;
            font-weight: 500;
            animation: slideIn 0.3s ease-out;
        `;

    // Add animation keyframes
    const style = document.createElement('style');
    style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
        `;
    document.head.appendChild(style);

    notification.textContent = message;
    document.body.appendChild(notification);

    // Remove notification after 3 seconds
    setTimeout(() => {
      notification.style.animation = 'slideIn 0.3s ease-out reverse';
      setTimeout(() => {
        if (notification.parentNode) {
          notification.parentNode.removeChild(notification);
        }
        if (style.parentNode) {
          style.parentNode.removeChild(style);
        }
      }, 300);
    }, 3000);
  }

  // Main event handler
  async function handleCtrlC(event) {
    // Check if Ctrl+C is pressed (or Cmd+C on Mac)
    if ((event.ctrlKey || event.metaKey) && event.key === 'c') {
      // Only trigger if we're not in an input field
      const activeElement = document.activeElement;
      const isInInputField = activeElement && (
        activeElement.tagName === 'INPUT' ||
        activeElement.tagName === 'TEXTAREA' ||
        activeElement.contentEditable === 'true'
      );

      // Check if there's any selected text
      const hasSelection = window.getSelection().toString().length > 0;

      // Only proceed if we're not in an input field and there's no text selection
      if (!isInInputField && !hasSelection) {
        event.preventDefault();

        console.log('Extracting JIRA task...');
        const markdown = extractJiraTask();

        if (markdown) {
          const success = await copyToClipboard(markdown);
          if (success) {
            console.log('JIRA task copied to clipboard!');
            showNotification('✅ JIRA task copied to clipboard!');
          } else {
            console.error('Failed to copy to clipboard');
            showNotification('❌ Failed to copy to clipboard', false);
          }
        } else {
          console.error('Failed to extract JIRA task');
          showNotification('❌ Failed to extract JIRA task', false);
        }
      }
    }
  }

  // Check if we're on a JIRA page
  function isJiraPage() {
    return window.location.href.includes('atlassian.net') ||
    document.querySelector('[data-testid="issue.views.issue-base.foundation.summary.heading"]');
  }

  // Initialize the script
  function init() {
    if (isJiraPage()) {
      console.log('JIRA Task Extractor loaded. Press Ctrl+C (without selecting text) to extract task information.');

      // Add event listener for keydown
      document.addEventListener('keydown', handleCtrlC, true);

      // Show initialization notification
      // showNotification('🔧 JIRA Extractor loaded - Press Ctrl+C to extract task');
    } else {
      console.log('Not a JIRA page, script not activated.');
    }
  }

  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
