const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNotiOnReaciton = functions
    .region('asia-northeast3')
    .firestore
    .document('users/{userId}/answers/{documentId}')
    .onUpdate(async (change, context) => {

        const userId = context.params.userId;
        const documentId = context.params.documentId;

        const { fianceId, myName } = await getFianceId(userId);

        const recipientToken = await getRecipientToken(fianceId);
        console.log(`token: ${recipientToken}`);

        const beforeData = change.before.data();
        const afterData = change.after.data();
        const watchedField = 'reaction';

        if (recipientToken && beforeData[watchedField] == null && afterData[watchedField] !== null ) {
          console.log(`Field ${watchedField} changed from null to ${afterData[watchedField]} in document ${context.params.documentId}`);

            const message = {
                notification: {
                    title: `${myName}님이 새로운 반응을 남겼어요.`,
                    body: '어떤 반응을 남겼는지 확인해볼까요?',
                },
                token: recipientToken,
            };

            try {
                return await admin.messaging().send(message).then((results) => {
                console.log('Successfully sent notification action to partner user');
                return {success: true};
              });
            } catch (error) {
                console.error('Error sending noti on reaction:', error);
            }
        } else {
            console.error('Recipient token not found for partner user:', fianceId);
        }
    });


exports.sendNotificationToFiance = functions
    .region('asia-northeast3')
    .firestore
    .document('users/{userId}/answers/{documentId}')
    .onCreate(async (snapshot, context) => {
        const userId = context.params.userId;

        const { fianceId, myName } = await getFianceId(userId);

        // const userDoc = await admin.firestore().collection('users').doc(userID).get();
        // const userData = userDoc.data();

        const recipientToken = await getRecipientToken(fianceId);

        console.log(`token: ${recipientToken}`);


        if (recipientToken) {
            // 필요시 사용 // fcm_token 이 있다는 건 파트너가 있다는 의미여서 if 문 제거
            const partnerUserDoc = await admin.firestore().collection('users').doc(fianceId).get();
            const partnerUserData = partnerUserDoc.data();

            const message = {
                notification: {
                    title: `${myName}님이 답변을 작성했어요.`,
                    body: '답변을 확인하고 반응을 남겨볼까요?',
                },
                token: recipientToken,
            };

            try {
                return await admin.messaging().send(message).then((results) => {
                console.log('Successfully sent message to partner user');
                return {success: true};
              });
            } catch (error) {
                console.error('Error sending message to partner user:', error);
            }
        } else {
            console.error('Recipient token not found for partner user:', fianceId);
        }
    });

async function getFianceId(userId) {
  try {
    const userDoc = await admin.firestore().collection('users').doc(userId).get();

    if (!userDoc.exists) {
        console.error(`User document with ID ${userId} does not exist`);
        return;
    }

    const userData = userDoc.data();
    const fianceId = userData.fiance;
    const myName = userData.name;

    return { fianceId, myName }

  }  catch (error) {
      console.error('Error fetching fianceId:', error);
      return null;
  }
}

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
