import { getAuth } from "firebase/auth";

const auth = getAuth();
const user = auth.currentUser;

const functions = require('firebase-functions');
const admin = require('firebase-admin');


require("firebase-functions/logger/compat");

admin.initializeApp();

exports.sendNotificationToUser = functions
    .region('asia-northeast3')
    .firestore
    .document('users/{userID}/answers/')
    .onCreate(async (snapshot, context) => {

        const userID = user.uid;

        const userDoc = await admin.firestore().collection('users').doc(userID).get();

        const userData = userDoc.data();
        const fianceId = userData.fiance;

        const fianceDoc = await admin.firestore().collection('users').doc(fianceId).get();

        if (fianceDoc.exists) {

            const recipientToken = await getRecipientToken(fianceId);

            console.log("token: \(recipientToken)");

            const fianceData = fianceData.data();

            if (recipientToken) {
                const message = {
                    data: {
                        title: '\(fianceData.name)님이 답변을 작성했어요.',
                        body: '답변을 확인하고 반응을 남겨볼까요?',
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
        } else {
            console.error(`User document with ID ${userID} does not exist`);
        }
    });

async function getRecipientToken(fianceId) {
    try {
        // Retrieve the FCM token from Firestore based on the partner user's ID.
        const userDoc = await admin.firestore().collection('users').doc(fianceId).get();

        if (userDoc.exists) {
            const userData = userDoc.data();
            console.log(`fcm_token ${userData.fcm_token}`);
            return userData.fcm_token;
        } else {
            console.log("no partner fcm_token");
            return null;
        }
    } catch (error) {
        console.error('Error fetching recipient token:', error);
        return null;
    }
}
