// Custom service worker for PWA update detection.
// Does NOT auto-skipWaiting — waits for user to trigger the update.

const CACHE_NAME = 'ping-cache-v1';

self.addEventListener('install', () => {
  // Stay in "waiting" state until the user chooses to update.
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('message', (event) => {
  if (event.data === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});
