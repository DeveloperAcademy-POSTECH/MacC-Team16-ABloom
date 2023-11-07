/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationToUser = functions.firestore
    .document('users/{userID}/answers/{documentId}')
    .onCreate(async (snapshot, context) => {

        const userID = firebase.auth().currentUser.user_id;
        const partnerUserId = firebase.auth().currentUser.fiance;

        const newDocumentData = snapshot.data();

        const recipientToken = await getRecipientToken(partnerUserId);

        if (recipientToken) {
            const message = {
                data: {
                    title: 'New Document Created by Your Partner',
                    body: 'A new document has been created by your partner user.',
                },
                token: recipientToken,
            };

            try {
                await admin.messaging().send(message);
                console.log('Successfully sent message to partner user');
            } catch (error) {
                console.error('Error sending message to partner user:', error);
            }
        } else {
            console.error('Recipient token not found for partner user:', partnerUserId);
        }
    });

async function getRecipientToken(userId) {
    try {
        // Retrieve the FCM token from Firestore based on the partner user's ID.
        const userDoc = await admin.firestore().collection('users').doc(userId).get();

        if (userDoc.exists) {
            const userData = userDoc.data();
            return userData.fcm_Token;
        } else {
            return null;
        }
    } catch (error) {
        console.error('Error fetching recipient token:', error);
        return null;
    }
}
