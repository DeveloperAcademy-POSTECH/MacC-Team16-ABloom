const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNotificationToFiance = functions
    .region('asia-northeast3')
    .firestore
    .document('users/{userID}/answers/{documentId}')
    .onCreate(async (snapshot, context) => {
        const userID = context.params.userID;

        const userDoc = await admin.firestore().collection('users').doc(userID).get();

        if (!userDoc.exists) {
            console.error(`User document with ID ${userID} does not exist`);
            return;
        }

        const userData = userDoc.data();
        const fianceId = userData.fiance;

        const recipientToken = await getRecipientToken(fianceId);

        console.log(`token: ${recipientToken}`);

        if (recipientToken) {
            const partnerUserDoc = await admin.firestore().collection('users').doc(fianceId).get();

            if (partnerUserDoc.exists) {
                const partnerUserData = partnerUserDoc.data();
                const partnerUserName = partnerUserData.name;

                  console.log(`fianceName: ${partnerUserName}`);

                const message = {
                    data: {
                        title: `${partnerUserName}님이 답변을 작성했어요.`,
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
                console.error(`Partner user document with ID ${fianceId} does not exist`);
            }
        } else {
            console.error('Recipient token not found for partner user:', fianceId);
        }
    });

async function getRecipientToken(fianceId) {
    try {
        // Retrieve the FCM token from Firestore based on the partner user's ID.
        const userDoc = await admin.firestore().collection('users').doc(fianceId).get();

        if (userDoc.exists) {
            const userData = userDoc.data();
            return userData.fcm_token;
        } else {
            console.error("no partner fcm_token");
            return null;
        }
    } catch (error) {
        console.error('Error fetching recipient token:', error);
        return null;
    }
}
