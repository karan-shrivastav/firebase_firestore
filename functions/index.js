// functions/index.js

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('tasks/{taskId}')
    .onCreate(async (snapshot, context) => {
        try {
            const newData = snapshot.data();

            // Customize the notification payload
            const payload = {
                notification: {
                    title: 'New Data Added',
                    body: `New data: ${newData.fieldName || 'Default field'}`, // Update this to access the correct field
                },
            };

            // Get the FCM tokens of devices to send the notification
            const tokensSnapshot = await admin.firestore().collection('tasks').get();
            const registrationTokens = tokensSnapshot.docs.map((doc) => doc.data().token);

            // Send FCM notification
            await admin.messaging().sendToDevice(registrationTokens, payload);

            console.log('Notification sent successfully');
            return null;
        } catch (error) {
            console.error('Error sending notification:', error);
            return null;
        }
    });

