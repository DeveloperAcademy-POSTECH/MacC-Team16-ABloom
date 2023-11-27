const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNotiConnection = functions
    .region('asia-northeast3')
    .firestore
    .document('users/{userId}')
    .onUpdate(async (change, context) => {

        const userId = context.params.userId;
        const recipientToken = await getRecipientToken(userId);

        const beforeData = change.before.data();
        const afterData = change.after.data();
        const watchedField = 'fiance';

        if (recipientToken && beforeData[watchedField] == null && afterData[watchedField] != null) {
          console.log(`Field ${watchedField} changed from null to ${afterData[watchedField]}`);

          const { fianceId, myName } = await getFianceId(userId);
          const fianceName = await getFianceName(fianceId);
          console.log(`fianceName: ${fianceName}`)

          const message = {
            notification: {
                title: `${fianceName}님과 연결됐어요!`,
                body: '이제 둘만의 첫 문답을 완성해 보세요 ✅',
            },
              token: recipientToken,
          };

          try {
              return await admin.messaging().send(message).then((results) => {
              console.log('Successfully sent connecion notification');
              return {success: true};
            });
          } catch (error) {
              console.error('Error sending noti on reaction:', error);
          }
        } else {
          console.error('Recipient token not found for me:', userId);
        }
    });

exports.sendNotiOnCompletion = functions
    .region('asia-northeast3')
    .firestore
    .document('users/{userId}/answers/{documentId}')
    .onUpdate(async (change, context) => {

        const userId = context.params.userId;
        const documentId = context.params.documentId;

        const { fianceId, myName } = await getFianceId(userId);

        const recipientToken = await getRecipientToken(fianceId);

        const ansQid = await getQid(userId, documentId);

        console.log(`qid: ${ansQid}`)

        const beforeData = change.before.data();
        const afterData = change.after.data();
        const watchedField = 'is_complete';

        if (recipientToken && beforeData[watchedField] == false && afterData[watchedField] == true ) {
          console.log(`Field ${watchedField} changed from false to ${afterData[watchedField]} in document ${context.params.documentId}`);

            const message = {
              data: {
                viewToOpen: 'AnswerCheck',
                qid: `${ansQid}`
              },
                notification: {
                    title: `둘만의 문답이 완성됐어요!`,
                    body: '행복한 결혼 생활에 한 걸음 더 다가갔어요 💕',
                },
                token: recipientToken,
            };

            try {
                return await admin.messaging().send(message).then((results) => {
                console.log('Successfully sent notification completion to partner user');
                return {success: true};
              });
            } catch (error) {
                console.error('Error sending noti on reaction:', error);
            }
        } else {
            console.error('Recipient token not found for partner user:', fianceId);
        }
    });

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

        const ansQid = await getQid(userId, documentId);
        console.log(`qid: ${ansQid}`)

        const beforeData = change.before.data();
        const afterData = change.after.data();
        const watchedField = 'reaction';

        if (recipientToken && beforeData[watchedField] == null && afterData[watchedField] !== null ) {
          console.log(`Field ${watchedField} changed from null to ${afterData[watchedField]} in document ${context.params.documentId}`);

            const message = {
              data: {
                viewToOpen: 'AnswerCheck',
                qid: `${ansQid}`
              },
                notification: {
                    title: `${myName}님이 반응을 남겼어요.`,
                    body: '어떤 반응을 남겼는지 확인해 볼까요? 👀',
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
        const documentId = context.params.documentId;

        const { fianceId, myName } = await getFianceId(userId);

        // const userDoc = await admin.firestore().collection('users').doc(userID).get();
        // const userData = userDoc.data();

        const recipientToken = await getRecipientToken(fianceId);
        console.log(`token: ${recipientToken}`);

        const ansQid = await getQid(userId, documentId);
        console.log(`qid: ${ansQid}`)

        if (recipientToken) {
            // 필요시 사용 // fcm_token 이 있다는 건 파트너가 있다는 의미여서 if 문 제거
            const partnerUserDoc = await admin.firestore().collection('users').doc(fianceId).get();
            const partnerUserData = partnerUserDoc.data();

            const message = {
              data: {
                viewToOpen: 'AnswerCheck',
                qid: `${ansQid}`
              },
                notification: {
                    title: `${myName}님이 답변을 작성했어요.`,
                    body: '과연 어떤 답변을 남겼을까요? 🤔',
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

async function getFianceName(fianceId) {
  try {
    const userDoc = await admin.firestore().collection('users').doc(fianceId).get();

    if (!userDoc.exists) {
        console.error(`User document with ID ${userId} does not exist`);
        return;
    }

    const userData = userDoc.data();
    const fianceName = userData.name;

    return fianceName

  }  catch (error) {
      console.error('Error fetching fianceId:', error);
      return null;
  }
}

async function getRecipientToken(userId) {
    try {
        const userDoc = await admin.firestore().collection('users').doc(userId).get();

        if (userDoc.exists) {
            const userData = userDoc.data();
            return userData.fcm_token;
        } else {
            console.error("no fcm_token");
            return null;
        }
    } catch (error) {
        console.error('Error fetching recipient token:', error);
        return null;
    }
}

async function getQid(userId, documentId) {
    try {
        const userAnsDoc = await admin.firestore().collection('users').doc(userId).collection('answers').doc(documentId).get()


        if (userAnsDoc.exists) {
            const userAnsData = userAnsDoc.data();
            console.error("in userAnsDoc");
            return userAnsData.q_id;
        } else {
            console.error("no docId");
            return null;
        }
    } catch (error) {
        console.error('Error fetching qid value:', error);
        return null;
    }
}
