importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: 'AIzaSyChPYtnc5VN_LmLGX89BpDCszpHJNyd08o',
  appId: '1:183358730638:web:b9d890a267b7bc59dc34df',
  messagingSenderId: '183358730638',
  projectId: 'bykman',
  authDomain: 'bykman.firebaseapp.com',
  databaseURL: 'https://bykman-default-rtdb.firebaseio.com',
  storageBucket: 'bykman.firebasestorage.app',
  measurementId: 'G-6Y4JMHP6X1',
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});